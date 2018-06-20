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
    
    //var poolArray: Array<Any> = []
    var typeValue = ""
     var pickerView = UIPickerView()
    
    var poolIDArray: Array<String> = []
     var poolNameArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAssetList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Gets the asset lists from the server
    func getAssetList(){
         ref = Database.database().reference()
        ref.child("Assets").observeSingleEvent(of: .value, with: { (snapshot) in
            assetList = snapshot.value as! NSDictionary
            
            self.getBenched()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // gets the list of benches assets from the assetList array
    func getBenched(){
        let idlist = assetList.allKeys
        for id in idlist {
            let asset = assetList.value(forKey: id as! String) as! NSDictionary
            if(asset.value(forKey: "bench") as! Int == 1){
                poolIDArray.append(id as! String)
                poolNameArray.append(asset.value(forKey: "Name") as! String)
            }
        }
        tableView.reloadData()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poolNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
        cell.textLabel?.text = (poolNameArray[indexPath.row])
        return cell
    }
    
    /*
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
        
        return [move, delete]
     
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
    
    */
    
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
