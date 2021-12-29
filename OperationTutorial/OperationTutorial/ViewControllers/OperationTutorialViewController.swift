//
//  ViewController.swift
//  OperationTutorial
//
//  Created by Developer on 20/12/21.
//

import UIKit
import WebKit

class OperationTutorialViewController: UIViewController{
    
    @IBOutlet weak var loadButton: UIButton!
    
    
    let queue = OperationQueue()
    var url = URL(string: "http://www.apple.com")
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   
  
//    @IBAction func performOperationTapped(_ sender: UIButton) {
//        let operation:NetworkOperation = NetworkOperation(url: url!, requestData: requestBody){ data, error in
//            let responseData = data
//            let string = String(data: responseData!, encoding: .utf8)
//            DispatchQueue.main.async {
//                self.webView.loadHTMLString(string!, baseURL: self.url)
//            }
//        }
//    }
}


