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
    @IBOutlet var segmentControl: UISegmentedControl!
    
    //var poolArray: Array<Any> = []
    var typeValue = ""
    var pickerView = UIPickerView()
    
    var poolIDArray: Array<String> = []
    var poolNameArray: Array<String> = []
    var segmentChoice = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAssetList()
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
        getLocationList()
    }
    //////
    
    
    func getLocationList(){
        ref = Database.database().reference()
        ref.child("Location").observeSingleEvent(of: .value, with: { (snapshot) in
            locationList = snapshot.value as! NSDictionary
            self.sortLocations()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    struct LocAsset {
        var sectionName : String!
        var sectionObjects : [String]!
    }
     var LocAssetArray = [LocAsset]()
    
    
    func sortLocations(){
        let catlist = locationList.allKeys
         for cat in catlist {
            let UserList = locationList.value(forKey: cat as! String) as! NSDictionary
            var temp: Array<String> = []
            for user in UserList.allKeys {
              
            let id = UserList.value(forKey: user as! String) as! String
            let index = poolIDArray.index(of: id)
            temp.append(poolNameArray[index!])
 
            // temp.append(UserList.value(forKey: user as! String) as! String)
            }
            LocAssetArray.append(LocAsset(sectionName: cat as! String, sectionObjects: temp))
        }
        getSkillList()
    }
    ////
    
   
    func getSkillList(){
        ref = Database.database().reference()
        ref.child("Skills").observeSingleEvent(of: .value, with: { (snapshot) in
            skillList = snapshot.value as! NSDictionary
            self.sortSkills()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    struct skillAsset {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    var SkillsetArray = [skillAsset]()
    
    
    func sortSkills(){
        let catlist = skillList.allKeys
        for cat in catlist {
            let UserList = skillList.value(forKey: cat as! String) as! NSDictionary
            var temp: Array<String> = []
            for user in UserList.allKeys {
                
                let id = UserList.value(forKey: user as! String) as! String
                let index = poolIDArray.index(of: id)
                temp.append(poolNameArray[index!])
                
                // temp.append(UserList.value(forKey: user as! String) as! String)
            }
            SkillsetArray.append(skillAsset(sectionName: cat as! String, sectionObjects: temp))
        }
        tableView.reloadData()
    }
    
    
    
    
    
    ////////////////////////////////////////////
    
    @IBAction func SegmentChange(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
            case 0:
                segmentChoice = 0;
            case 1:
                segmentChoice = 1;
            case 2:
                segmentChoice = 2;
            default:
                break
        }
        tableView.reloadData()
    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(segmentChoice == 0){
            return 1
        }
        else if(segmentChoice == 1){
            return LocAssetArray.count
        }
        else{
             return SkillsetArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(segmentChoice == 0){
           return poolNameArray.count
        }
        else if(segmentChoice == 1){
            if(LocAssetArray.count != 0){
                return LocAssetArray[section].sectionObjects.count
            }
            else{
                return 0
            }
        }
        else{
            if(SkillsetArray.count != 0){
                return SkillsetArray[section].sectionObjects.count
            }
            else{
                return 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(segmentChoice == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
            cell.textLabel?.text = (poolNameArray[indexPath.row])
            return cell
        }
        else if(segmentChoice == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
            cell.textLabel?.text =  LocAssetArray[indexPath.section].sectionObjects[indexPath.row]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
            cell.textLabel?.text =  SkillsetArray[indexPath.section].sectionObjects[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(segmentChoice == 0){
            return ""
        }
        else if(segmentChoice == 1){
             return LocAssetArray[section].sectionName
        }
        else{
            return SkillsetArray[section].sectionName
        }
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
   
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
