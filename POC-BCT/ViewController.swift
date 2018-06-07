//
//  ViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/7/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import UIKit
import Firebase



var CurrentProj = ""

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var ProjectTableView: UITableView!
    
    var ref: DatabaseReference!
    var projArray: Array<Any> = []
    
    
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
            
           self.projArray = Array(eventsDictionary.allKeys)
           self.ProjectTableView.reloadData()
         }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
        cell.textLabel?.text = (self.projArray[indexPath.row] as! String)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CurrentProj = self.projArray[indexPath.row] as! String
        print("here")
        
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assets") as! AssetViewController
        self.present(loginVC, animated: true, completion: nil)
    }


}

