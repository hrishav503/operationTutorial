//
//  LoginViewController.swift
//  OperationTutorial
//
//  Created by Developer on 21/12/21.
//

import UIKit
class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isLoading : Bool = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var parser = XMLParser()
    var parsedData:String = ""
    var content:String = ""
    let url = URL(string: "https://opsmobile_eb_test.jetstar.com/EB_WWS.svc")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setBackgroundOrientation(){
        
        let deviceOrientation = UIDevice.current.orientation
        
        if deviceOrientation == .landscapeLeft || deviceOrientation == .landscapeRight {
            backgroundImageView.image = UIImage(named: "LoginBackgroundLandscape")
            
        }else if deviceOrientation == .portrait || deviceOrientation == .portraitUpsideDown {
            backgroundImageView.image = UIImage(named: "LoginBackgroundPortrait")
            
        }
    }
    
    func setupUI(){
        clearButton.layer.borderWidth = 0.5
        clearButton.layer.borderColor = UIColor.orange.cgColor
        hideActivityIndicator()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_ :)))
        
        backgroundImageView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender:UIButton){
        performOperation()
    }
    
    func showActivityIndicator(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func embed(inSOAPEnvelope soapBody: String, soapAction: String) -> String {
        
        let strMessage: String = "<s:Envelope xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\">" +
        "<s:Header>" +
        "<a:Action s:mustUnderstand=\"1\">http://Jetstar.com/IEB_WWS/\(soapAction)</a:Action>" +
        "</s:Header>" +
        "<s:Body>" +
        "\(soapBody)" +
        "</s:Body>" +
        "</s:Envelope>"
        
        return strMessage
    }
    
    func performOperation() {
        
        showActivityIndicator()
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let soapAction: String = "Validate_EB_App_User"
        let requestBody = "<Validate_EB_App_User xmlns=\"http://Jetstar.com/\">" +
        "<EB_CW_NUM>\(username)</EB_CW_NUM>" +
        "<Pwd>\(password)</Pwd>" +
        "</Validate_EB_App_User>"
        
        let soapMessage: String = embed(inSOAPEnvelope: requestBody, soapAction: soapAction)
        
        _ = NetworkOperation(url: url!, requestData: soapMessage){ data, error in
            let responseData = data
            let string = String(data: responseData!, encoding: .utf8)
            print("the response: ", string)
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.parser = XMLParser(data: data!)
                self.parser.delegate = self
                self.parser.parse()
                
            }
        }
    }
}

extension LoginViewController: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        parsedData.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Validate_EB_App_UserResult" {
            parsedData.removeAll()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Validate_EB_App_UserResult" {
            parsedData = content
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        content = string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        performSegue(withIdentifier: "goToFlightDetailVc", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? FlightPlanTableViewController else {return}
        // vc.crewDetailData = parsedData
        let jsonData = parsedData.data(using: .utf8)
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData!, options: [])  as? [String:Any]
            print("The Json serialized data", jsonObject)
            let rootDictionary = jsonObject!["EB_ValidateFlightPlanAppUser_Response"] as? [String:Any]
            //     print("the root dictionary", rootDictionary) as? [String: Any]
            
            guard let userDictionary = rootDictionary!["EmpBasicData"] as? [String:Any] else {
                print(Error.self)
                return;
            }
            
            guard let flightDictionary = rootDictionary!["EmpRosters"] else {
                print(Error.self)
                print("error parsing flight dict")
                return;
            }
            
            print("the flight dictionary", flightDictionary) as? [String: Any]
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let username = usernameTextField.text!
            let password = passwordTextField.text!
            
            let user:User? = User.insertOrUpdateUser(username: username, password: password, userDictionary: userDictionary, context: context)
            
            
            let flight = Flight.getEmployeeRooster(user: user!, flightPlanDictionary: flightDictionary, context: context)
            
            do {
                try context.save()
                print("user saved succesfully.")
                
            } catch {
                print(error.localizedDescription)
                
            }
            
        } catch {
            print(error)
        }
    }
    
}
