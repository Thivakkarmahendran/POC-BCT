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



class AssetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    var ref: DatabaseReference!
    var assetArray: Array<Any> = []
    
    @IBOutlet var AssetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAssetList()
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
                let temp1 = (temp as AnyObject).components(separatedBy: ",")
                
                self.assetArray = temp1
                self.AssetTableView.reloadData()
            }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
        cell.textLabel?.text = (self.assetArray[indexPath.row] as! String)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
}

