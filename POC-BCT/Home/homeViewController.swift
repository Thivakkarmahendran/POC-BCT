//
//  homeViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/11/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class homeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
   
    let titles = ["Projects", "General Pool", "Create Project", "Create Assset"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! homeCollectionCell
        cell.cellTitle.text = titles[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "project") as! ProjectViewController
            self.present(loginVC, animated: true, completion: nil)
        }
       else if(indexPath.row == 2){
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createproj") as! ProjectCreateTableViewController
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    

}
