//
//  PoolViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/13/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PoolViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var poolArray: Array<Any> = []
     var ref: DatabaseReference!
      var typeValue = ""
    
     var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPoolList()
        getProjectList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPoolList(){
        poolArray.removeAll()
        var eventsDictionary: NSDictionary = NSDictionary()
        
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventDict = snapshot.value as?  [String:Any] {
                eventsDictionary = eventDict as NSDictionary
                let temp = eventsDictionary.value(forKey: "Pool")
                if(temp == nil){
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
                    self.present(loginVC, animated: true, completion: nil)
                }
                else{
                    self.poolArray = temp as! Array<Any>
                    self.tableView.reloadData()
                }
              }
             else{
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
                self.present(loginVC, animated: true, completion: nil)
            }
        })
    }
    
    
    func getProjectList(){
        projArray.removeAll()
        var eventsDictionary: NSDictionary = NSDictionary()
        
        ref = Database.database().reference().child("Users").child(UserID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventDict = snapshot.value as?  [String:Any] {
                eventsDictionary = eventDict as NSDictionary
                let temp = eventsDictionary.value(forKey: "Projects")
                projArray = temp as! Array<Any>
            }
        })
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poolArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
        cell.textLabel?.text = (poolArray[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let temparray = [String]()
            let ref = Database.database().reference().child("Assets").child(self.poolArray[indexPath.row] as! String).setValue(temparray)
            self.poolArray.remove(at: indexPath.row)
            let ref2 = Database.database().reference().child("Pool").setValue(self.poolArray)
            self.tableView.reloadData()
        }
        
        
        
        let move = UITableViewRowAction(style: .default, title: "Move") { (action, indexPath) in
            print(projArray)
            
            let alert = UIAlertController(title: "Move to:", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            alert.isModalInPopover = true
            
            let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
            
            alert.view.addSubview(pickerFrame)
            pickerFrame.dataSource = self
            pickerFrame.delegate = self
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (UIAlertAction) in
                
                print("You selected " + self.typeValue)
                
                
                self.getAssetListofProj(proj: self.typeValue, asset: self.poolArray[indexPath.row] as! String)
                
                self.poolArray.remove(at: indexPath.row)
                let ref = Database.database().reference().child("Pool").setValue(self.poolArray)
                
                self.tableView.reloadData()
            }))
            self.present(alert,animated: true, completion: nil )
            
        }
        move.backgroundColor = UIColor.blue
        
        return [delete, move]
    }
    
    func getAssetListofProj(proj:String, asset: String){
        var assetArrayProj: Array<Any> = []
        var eventsDictionary: NSDictionary = NSDictionary()
        
        ref = Database.database().reference().child("Projects").child(proj)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventDict = snapshot.value as?  [String:Any] {
                eventsDictionary = eventDict as NSDictionary
                
                let temp = eventsDictionary.value(forKey: "Asset List")
                if(temp != nil){
                    assetArrayProj = temp as! Array<Any>
                }
                assetArrayProj.append(asset)
                let ref = Database.database().reference().child("Projects").child(proj).child("Asset List").setValue(assetArrayProj)
            }
        })
    }
    
    
    ///////////// PICKER
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return projArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return projArray[row] as! String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeValue = projArray[row] as! String
    }
    ////////////
    
    @IBAction func backButton(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
}
