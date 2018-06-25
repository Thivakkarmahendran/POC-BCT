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

var userProjAssetIDList: Array<String> = []

var CurrentProjectAssetArray: Array<String> = []

var cProject: NSDictionary = [:]


var ref: DatabaseReference!
class global: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
