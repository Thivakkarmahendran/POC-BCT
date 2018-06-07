//
//  ProjectDetailTableViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/7/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProjectDetailTableViewController: UITableViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = CurrentProj
        getProjInfo()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProjInfo(){
        
        var eventsDictionary: NSDictionary = NSDictionary()
        
        ref = Database.database().reference().child("Projects").child(CurrentProj)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventDict = snapshot.value as?  [String:Any] {
                eventsDictionary = eventDict as NSDictionary
                
                self.titleLabel.text = CurrentProj
                
                let temp = eventsDictionary.value(forKey: "Project ID")
                if(temp != nil){
                    self.idLabel.text = String(temp as! Int)
                }
                
                let temp1 = eventsDictionary.value(forKey: "Cost when idle")
                if(temp1 != nil){
                    self.costLabel.text = "$ \(temp1!)"
                }
                
                let temp2 = eventsDictionary.value(forKey: "Value when Active")
                if(temp2 != nil){
                    self.valueLabel.text = "$ \(temp2!)"
                }
                
                
            }
        })
        
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "project") as! ViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    
}
