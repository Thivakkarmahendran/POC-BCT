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
   
    let titles = ["Projects", "Pool (Assets)", "Create Project", "Create Asset"]
    
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
        
        
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 4.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "project") as! ProjectViewController
            self.present(loginVC, animated: true, completion: nil)
        }
        else if(indexPath.row == 1){
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pool") as! PoolViewController
            self.present(loginVC, animated: true, completion: nil)
        }
       else if(indexPath.row == 2){
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createproj") as! ProjectCreateTableViewController
            self.present(loginVC, animated: true, completion: nil)
        }
        else if(indexPath.row == 3){
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createasset") as! AssetCreateTableViewController
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    

}
