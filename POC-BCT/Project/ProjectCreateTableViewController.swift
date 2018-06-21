//
//  ProjectCreateTableViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/12/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProjectCreateTableViewController: UITableViewController {
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var ProjectIDTextField: UITextField!
    @IBOutlet var costTextField: UITextField!
    @IBOutlet var skillsTextField: UITextField!
    @IBOutlet var startDate: UIDatePicker!
    @IBOutlet var endDate: UIDatePicker!
    
     var ref1: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uuid = UUID().uuidString
        ProjectIDTextField.text = uuid
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreateButton(_ sender: Any) {
        if((NameTextField.text != "") && (ProjectIDTextField.text != "") && (costTextField.text != "") && (skillsTextField.text != "")){
          
            
            let data = ["Name": NameTextField.text, "Budget": costTextField.text, "Skills": skillsTextField.text, "Start Date": Int(startDate.date.timeIntervalSince1970), "End Date": Int(startDate.date.timeIntervalSince1970)] as [String : Any]
            
            let ref = Database.database().reference().child("Projects").child(ProjectIDTextField.text!).setValue(data)
            
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
            self.present(loginVC, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "A text field is empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func CancelButton(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
   
    
}

