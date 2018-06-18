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
    @IBOutlet var ValueTextField: UITextField!
    
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
        if((NameTextField.text != "") && (ProjectIDTextField.text != "") && (costTextField.text != "") && (ValueTextField.text != "")){
          
            let data = ["Project ID": ProjectIDTextField.text, "Cost when idle": costTextField.text, "Value when Active":ValueTextField.text]
            let ref = Database.database().reference().child("Projects").child(NameTextField.text!).setValue(data)
            
            getListofProj(proj: NameTextField.text!)
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
    
    func getListofProj(proj: String){
        var assetArrayProj: Array<Any> = []
        var eventsDictionary: NSDictionary = NSDictionary()
        
        ref1 = Database.database().reference().child("Users").child(UserID)
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventDict = snapshot.value as?  [String:Any] {
                eventsDictionary = eventDict as NSDictionary
                let temp = eventsDictionary.value(forKey: "Projects")
                
                
                if(temp != nil){
                    assetArrayProj = temp as! Array<Any>
                }
                assetArrayProj.append(proj)
                
                
                let ref = Database.database().reference().child("Users").child(UserID).child("Projects").setValue(assetArrayProj)
                
             
                
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
                self.present(loginVC, animated: true, completion: nil)
            }
            else{
                assetArrayProj.append(proj)
                let ref = Database.database().reference().child("Users").child(UserID).child("Projects").setValue(assetArrayProj)
                
                
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
                self.present(loginVC, animated: true, completion: nil)
            }
        })
    }
    
    
}

