//
//  CrewDetailViewController.swift
//  OperationTutorial
//
//  Created by Developer on 22/12/21.
//

import UIKit

class CrewDetailViewController: UIViewController {

    var crewDetailData: String?
    
    @IBOutlet weak var crewDataLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        crewDataLabel.text = crewDetailData
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
