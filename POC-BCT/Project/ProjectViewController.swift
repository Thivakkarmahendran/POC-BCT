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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        getProjectList(Loc: "Projectview")
    }
    
    
    @objc func loadList(){
        if(projArray.count == 0){
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
            self.present(loginVC, animated: true, completion: nil)
        }
        else{
            self.ProjectTableView.reloadData()
        }
    }
    
    
    
    
    //////Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
        cell.textLabel?.text = (projArray[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let info = UITableViewRowAction(style: .default, title: "Info") { (action, indexPath) in
            CurrentProj = projArray[indexPath.row] as! String
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjDetails") as! ProjectDetailTableViewController
            self.present(loginVC, animated: true, completion: nil)
        }
        info.backgroundColor = UIColor.blue
        
        return [info]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CurrentProj = projArray[indexPath.row] as! String
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assets") as! AssetViewController
        self.present(loginVC, animated: true, completion: nil)
    }

    @IBAction func backButton(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
}

