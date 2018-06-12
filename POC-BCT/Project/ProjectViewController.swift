//
//  ViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/7/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import UIKit
import Firebase





class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var ProjectTableView: UITableView!
    
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         getProjectList()
    }
    
    func getProjectList(){
         projArray.removeAll()
         var eventsDictionary: NSDictionary = NSDictionary()
        
         ref = Database.database().reference().child("Projects")
         ref.observeSingleEvent(of: .value, with: { (snapshot) in
           if let eventDict = snapshot.value as?  [String:Any] {
             eventsDictionary = eventDict as NSDictionary
            
           projArray = Array(eventsDictionary.allKeys)
           self.ProjectTableView.reloadData()
         }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
        cell.textLabel?.text = (projArray[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let share = UITableViewRowAction(style: .default, title: "Info") { (action, indexPath) in
            CurrentProj = projArray[indexPath.row] as! String
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjDetails") as! ProjectDetailTableViewController
            self.present(loginVC, animated: true, completion: nil)
        }
        share.backgroundColor = UIColor.blue
        
        return [share]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CurrentProj = projArray[indexPath.row] as! String
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assets") as! AssetViewController
        self.present(loginVC, animated: true, completion: nil)
    }


}

