//
//  AssetViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/7/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase



class AssetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var pickerView = UIPickerView()
    var typeValue = "Project 3"
    var ref: DatabaseReference!
    var assetArray: Array<Any> = []
    
    @IBOutlet var AssetTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getAssetList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func SendTrans(asset: String, from: String, to: String){
        let data = ["Asset": asset, "From": from, "To":to]
    
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let ref = Database.database().reference().child("Transactions").child(String(year!)).child(String(month!)).child(String(day!)).child(String(hour!)).child(String(minute!)).child(String(second!)).setValue(data)
        
    }
    
    
    func getAssetList(){
        assetArray.removeAll()
        var eventsDictionary: NSDictionary = NSDictionary()
        
        ref = Database.database().reference().child("Projects").child(CurrentProj)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventDict = snapshot.value as?  [String:Any] {
                eventsDictionary = eventDict as NSDictionary
                
                let temp = eventsDictionary.value(forKey: "Asset List")
                if(temp != nil){
                    self.assetArray = temp as! Array<Any>
                    self.AssetTableView.reloadData()
                }
            }
        })
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
    
    
    func getPoolList(asset: String){
        var poolArray: Array<Any> = []
        var eventsDictionary: NSDictionary = NSDictionary()
        
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventDict = snapshot.value as?  [String:Any] {
                eventsDictionary = eventDict as NSDictionary
                let temp = eventsDictionary.value(forKey: "Pool")
               
                if(temp != nil){
                    poolArray = temp as! Array<Any>
                }
                poolArray.append(asset)
                let ref = Database.database().reference().child("Pool").setValue(poolArray)
            }
            else{
                poolArray.append(asset)
                let ref = Database.database().reference().child("Pool").setValue(poolArray)
            }
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
        cell.textLabel?.text = (self.assetArray[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            
            self.getPoolList(asset: self.assetArray[indexPath.row] as! String)
            
            self.assetArray.remove(at: indexPath.row)
            let ref = Database.database().reference().child("Projects").child(CurrentProj).child("Asset List").setValue(self.assetArray)
            self.AssetTableView.reloadData()
            //self.getAssetList()
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
                
                print("You selected " + self.typeValue )
                
                self.getAssetListofProj(proj: self.typeValue, asset: self.assetArray[indexPath.row] as! String)
                self.SendTrans(asset: self.assetArray[indexPath.row] as! String, from: CurrentProj, to: self.typeValue)
                
                self.assetArray.remove(at: indexPath.row)
                let ref = Database.database().reference().child("Projects").child(CurrentProj).child("Asset List").setValue(self.assetArray)
                self.getAssetList()
                
            }))
            self.present(alert,animated: true, completion: nil )
            
        }
        move.backgroundColor = UIColor.blue
        
        return [move,delete]
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
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "project") as! ProjectViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
}

