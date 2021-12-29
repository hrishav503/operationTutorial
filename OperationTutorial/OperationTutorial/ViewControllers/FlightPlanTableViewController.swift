//
//  FlightPlanTableViewController.swift
//  OperationTutorial
//
//  Created by Developer on 24/12/21.
//

import UIKit
import CoreData

class FlightPlanTableViewController: UITableViewController {
    
    var user = [User]()
    
    var flightPlan:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MyCustomHeader.self,
                           forHeaderFooterViewReuseIdentifier: "sectionHeader")
        fetchUserData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightPlanTableViewCell")
        cell?.textLabel?.text = flightPlan
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "sectionHeader") as! MyCustomHeader
        let user = user.last
        view.crewId.textAlignment = .right
        view.crewId.text = user?.crewNum
        view.crewUsername.textAlignment = .right
        view.crewUsername.text = (user?.firstName!)! + " " + (user?.lastName!)!
        // view.image.image = UIImage(named: sectionImages[section])
        tableView.reloadData()
        return view
        
    }
    
    func fetchUserData()        {
        
        let userContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do{
            
            let user = try userContext.fetch(fetchRequest)
            self.user = user
            tableView.reloadData()
            
        }
        catch {
            print("Error fetching the request")
        }
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class MyCustomHeader: UITableViewHeaderFooterView {
    let crewUsername = UILabel()
    let crewId = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        crewUsername.translatesAutoresizingMaskIntoConstraints = false
        crewId.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(crewUsername)
        contentView.addSubview(crewId)
        
        NSLayoutConstraint.activate([
            //          crewUsername.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 690),
            crewUsername.widthAnchor.constraint(equalToConstant: 300),
            crewUsername.heightAnchor.constraint(equalToConstant: 100),
            crewUsername.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: 2),
            //      crewUsername.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            crewId.heightAnchor.constraint(equalToConstant: 30),
            //         crewId.leadingAnchor.constraint(equalTo: crewUsername.trailingAnchor,
            //                constant: 8),
            crewId.trailingAnchor.constraint(equalTo:
                                                contentView.layoutMarginsGuide.trailingAnchor),
            //    crewId.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
