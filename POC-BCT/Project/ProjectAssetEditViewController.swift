//
//  ProjectAssetEditViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/25/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProjectAssetEditViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var assetPoolTableView: UITableView!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    var poolIDArray: Array<String> = []
    var poolNameArray: Array<String> = []
    var segmentChoice = 0
    
    var startDate  = Date()
    var endDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProjectList()
    }
    
    //Gets the project lists from the server
    func getProjectList(){
        ref = Database.database().reference()
        ref.child("Projects").observeSingleEvent(of: .value, with: { (snapshot) in
            ProjList = snapshot.value as! NSDictionary
            self.getAssetList1()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getAssetList1(){
          cProject = ProjList.value(forKey: CurrentProj) as! NSDictionary
        CurrentProjectAssetArray.removeAll()
        CurrentProjectAssetIDArray.removeAll()
        if(cProject.value(forKey: "Assets") != nil){
            let list = cProject.value(forKey: "Assets") as! NSDictionary
            userProjAssetIDList = list.allValues as! Array<String>
            let idlist = userProjAssetIDList
            for id in idlist {
                let asset = assetList.value(forKey: id as! String) as! NSDictionary
                CurrentProjectAssetArray.append(asset.value(forKey: "Name") as! String)
                CurrentProjectAssetIDArray.append(id)
            }
        }
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
        poolIDArray.removeAll()
        poolNameArray.removeAll()
        
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
        LocAssetArray.removeAll()
        let catlist = locationList.allKeys
        for cat in catlist {
            let UserList = locationList.value(forKey: cat as! String) as! NSDictionary
            var temp: Array<String> = []
            for user in UserList.allKeys {
                
                let id = UserList.value(forKey: user as! String) as! String
                let index = poolIDArray.index(of: id)
                if(index != nil){
                    temp.append(poolNameArray[index!])
                }
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
        SkillsetArray.removeAll()
        let catlist = skillList.allKeys
        for cat in catlist {
            let UserList = skillList.value(forKey: cat as! String) as! NSDictionary
            var temp: Array<String> = []
            for user in UserList.allKeys {
                
                let id = UserList.value(forKey: user as! String) as! String
                let index = poolIDArray.index(of: id)
                if(index != nil){
                    temp.append(poolNameArray[index!])
                }
                
                // temp.append(UserList.value(forKey: user as! String) as! String)
            }
            SkillsetArray.append(skillAsset(sectionName: cat as! String, sectionObjects: temp))
        }
        
        assetPoolTableView.reloadData()
        collectionView.reloadData()
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func getDatefromUser(assetID: String){
        let currentDateTime = Date()
        let alert = UIAlertController(style: .actionSheet, title: "Select start date")
        alert.addDatePicker(mode: .date, date: currentDateTime, minimumDate: currentDateTime, maximumDate: nil) { date in
            self.startDate = date
        }
        alert.addAction(image: nil, title: "Next", color: .black, style: .default) { action in
            let alert1 = UIAlertController(style: .actionSheet, title: "Select end date")
            alert1.addDatePicker(mode: .date, date: currentDateTime, minimumDate: currentDateTime, maximumDate: nil) { date1 in
                self.endDate = date1
            }
            alert1.addAction(image: nil, title: "Done", color: .black, style: .default) { action in
                if(self.startDate <= self.endDate){
                    self.addAssettoProject(assetID: assetID)
                }
                else{
                    let alert3 = UIAlertController(title: "Alert", message: "Start date is later than end date", preferredStyle: UIAlertControllerStyle.alert)
                    alert3.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert3, animated: true, completion: nil)
                }
            }
            alert1.addAction(title: "Cancel", style: .cancel)
            self.present(alert1, animated: true, completion: nil)
        }
        
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func addAssettoProject(assetID: String){

        let data = ["Start": Int(startDate.timeIntervalSince1970), "End": Int(endDate.timeIntervalSince1970)]

        let ref = Database.database().reference().child("Projects").child(CurrentProj).child("Assets").child(assetID).setValue(assetID)
        let ref1 = Database.database().reference().child("Assets").child(assetID).child("bench").setValue(false)
        let ref2 = Database.database().reference().child("Assets").child(assetID).child("Assignment").child(CurrentProj).childByAutoId().setValue(data)
    
        
        
        
        
        //refresh view
        getProjectList()
        Analytics.logEvent("Add_Asset_to_Project", parameters: ["User_Id": UserID as NSObject, "Asset_Id": assetID as NSObject, "Project_ID": CurrentProj as NSObject])
    }
    
    
    
    func removeAssetfromProject(assetID: String){
        let ref = Database.database().reference().child("Projects").child(CurrentProj).child("Assets").child(assetID).removeValue()
        let ref1 = Database.database().reference().child("Assets").child(assetID).child("bench").setValue(true)
         let ref2 = Database.database().reference().child("Assets").child(assetID).child("Assignment").child(CurrentProj).removeValue()
        
        //refresh view
        getProjectList()
        Analytics.logEvent("Remove_Asset_from_Project", parameters: ["User_Id": UserID as NSObject, "Asset_Id": assetID as NSObject, "Project_ID": CurrentProj as NSObject])
    }
    
    
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentProjectAssetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! projectDetailCollectionCell
        
        cell.name.text = CurrentProjectAssetArray[indexPath.row]
        
        cell.image.layer.masksToBounds = false;
        cell.image.layer.cornerRadius = 8;
        cell.image.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.image.layer.shadowRadius = 5;
        cell.image.layer.shadowOpacity = 0.5;
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         removeAssetfromProject(assetID: CurrentProjectAssetIDArray[indexPath.row])
    }
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell1")!
            cell.textLabel?.text = (poolNameArray[indexPath.row])
            return cell
        }
        else if(segmentChoice == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell1")!
            cell.textLabel?.text =  LocAssetArray[indexPath.section].sectionObjects[indexPath.row]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell1")!
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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
     func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let add = UITableViewRowAction(style: .normal, title: "Add") { action, index in
            if(self.segmentChoice == 0){
                  self.getDatefromUser(assetID: self.poolIDArray[index.row])
            }
            else if(self.segmentChoice == 1){
                let temp =  self.LocAssetArray[index.section].sectionObjects[index.row]
                let temp1 = self.poolNameArray.index(of: temp)
                
                self.getDatefromUser(assetID: self.poolIDArray[temp1!])
                
            }
            else{
                let temp =  self.SkillsetArray[index.section].sectionObjects[index.row]
                let temp1 = self.poolNameArray.index(of: temp)
                self.getDatefromUser(assetID: self.poolIDArray[temp1!])
            }
        }
        add.backgroundColor = .blue
        return [add]
    }
    
    
    
    ///////
    @IBAction func segmentControl(_ sender: Any) {
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
        assetPoolTableView.reloadData()
        
    }
    

}
