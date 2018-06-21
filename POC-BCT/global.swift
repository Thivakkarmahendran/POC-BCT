//
//  globalVariables.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/12/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import  UIKit
import  Firebase


var assetList: NSDictionary = [:]
var locationList: NSDictionary = [:]
var skillList: NSDictionary = [:]
var UserID = ""
var userProjList: Array<String> = []
var ProjList: NSDictionary = [:]



var CurrentProj = ""
var projArray: Array<Any> = []
var ref: DatabaseReference!


func getProjectList(Loc: String){
    if(UserID != ""){
        projArray.removeAll()
        var projectDictionary: NSDictionary = NSDictionary()
        ref = Database.database().reference().child("Users").child(UserID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let projDict = snapshot.value as?  [String:Any] {
                projectDictionary = projDict as NSDictionary
                let temp = projectDictionary.value(forKey: "Projects")
                projArray = temp as! Array<Any>
                
                if(Loc == "Projectview"){
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProjectList"), object: nil)
                }
            }
            else{
                 print("******************ALERT: PROJECT LIST EMPTY****************")
            }
        })
    }
    else{
        print("******************ERROR: USER ID EMPTY: user is not logged in****************")
    }
}



class global: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
