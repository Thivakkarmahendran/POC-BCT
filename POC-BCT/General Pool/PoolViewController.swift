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

class PoolViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var poolArray: Array<Any> = []
     var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPoolList()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poolArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
        cell.textLabel?.text = (poolArray[indexPath.row] as! String)
        return cell
    }
    

}
