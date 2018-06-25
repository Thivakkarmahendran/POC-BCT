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
    @IBOutlet  var ProjectTableView: UITableView!

    var projNameArray: Array<String> = []
     var projIDArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAssetList()
    }
    
    //Gets the asset lists from the server
    func getAssetList(){
        ref = Database.database().reference()
        ref.child("Assets").observeSingleEvent(of: .value, with: { (snapshot) in
            assetList = snapshot.value as! NSDictionary
            self.getUserProjectList()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    //Gets the user project lists from the server
    func getUserProjectList(){
        ref = Database.database().reference()
        ref.child("Users").child(UserID).observeSingleEvent(of: .value, with: { (snapshot) in
            
                //print(snapshot.value!)
                let temp = snapshot.value as! NSDictionary
                let temp1 = temp.value(forKey: "Projects") as! NSDictionary
                userProjList =  temp1.allValues as! Array<String>
                self.getProjectList()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Gets the project lists from the server
    func getProjectList(){
        ref = Database.database().reference()
        ref.child("Projects").observeSingleEvent(of: .value, with: { (snapshot) in
            ProjList = snapshot.value as! NSDictionary
            self.convertIDtoProjName()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func convertIDtoProjName(){
        let idlist = ProjList.allKeys
        for id in idlist {
            let project = ProjList.value(forKey: id as! String) as! NSDictionary
            if(userProjList.contains(id as! String)){
                projIDArray.append(id as! String)
                projNameArray.append(project.value(forKey: "Name") as! String)
            }
        }
        ProjectTableView.reloadData()
    }
    
    
    //////Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
        cell.textLabel?.text = (projNameArray[indexPath.row] )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CurrentProj = projIDArray[indexPath.row]
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjDetails") as! ProjectDetailTableViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    
}

