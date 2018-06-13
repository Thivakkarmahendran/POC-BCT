//
//  AssetCreateTableViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/13/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AssetCreateTableViewController: UITableViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var assetIDTextField: UITextField!
    
     var ref1: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uuid = UUID().uuidString
        assetIDTextField.text = uuid
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreateButton(_ sender: Any) {
        
        if((nameTextField.text != "") && (assetIDTextField.text != "")){
            let data = ["Asset ID": assetIDTextField.text]
            let ref = Database.database().reference().child("Assets").child(nameTextField.text!).setValue(data)
            
             SavetoPool(asset: nameTextField.text!)
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
    
    func SavetoPool(asset: String){
        var assetArrayPool: Array<Any> = []
        var eventsDictionary: NSDictionary = NSDictionary()
        
        ref1 = Database.database().reference()
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventDict = snapshot.value as?  [String:Any] {
                eventsDictionary = eventDict as NSDictionary
                let temp = eventsDictionary.value(forKey: "Pool")
                
                if(temp != nil){
                    assetArrayPool = temp as! Array<Any>
                }
                assetArrayPool.append(asset)
                
                
                let ref = Database.database().reference().child("Pool").setValue(assetArrayPool)
                
                
                
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
                self.present(loginVC, animated: true, completion: nil)
            }
            else{
                assetArrayPool.append(asset)
                let ref = Database.database().reference().child("Pool").setValue(assetArrayPool)
                
                
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
                self.present(loginVC, animated: true, completion: nil)
            }
        })
    }
    
}
