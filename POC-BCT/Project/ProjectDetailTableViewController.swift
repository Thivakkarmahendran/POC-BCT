//
//  ProjectDetailTableViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/7/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProjectDetailTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    
    @IBOutlet var titleNavItem: UINavigationItem!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var budgetLabel: UILabel!
    @IBOutlet var skillsLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    var cProject: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cProject = ProjList.value(forKey: CurrentProj) as! NSDictionary
        updateProjectInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home1") as! homeTabController
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    func updateProjectInfo(){
        titleNavItem.title = cProject.value(forKey: "Name") as! String
        idLabel.text = CurrentProj
        budgetLabel.text = "\(cProject.value(forKey: "Budget")!)"
        skillsLabel.text = "\(cProject.value(forKey: "Skills")!)"
        
        let start = cProject.value(forKey: "Start Date")!
        let end = cProject.value(forKey: "End Date")!
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let sdate = Date(timeIntervalSince1970: start as! TimeInterval)
        let edate = Date(timeIntervalSince1970: end as! TimeInterval)
        
        startDateLabel.text = dateFormatter.string(from: sdate)
        endDateLabel.text = dateFormatter.string(from: edate)
        
    }
    
    ///////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! projectDetailCollectionCell
        
       // cell.image.layer.cornerRadius = cell.image.frame.size.width / 2
       // cell.image.clipsToBounds = true
        
         cell.image.layer.masksToBounds = false;
         cell.image.layer.cornerRadius = 8;
         cell.image.layer.shadowOffset = CGSize(width: 5, height: 5)
         cell.image.layer.shadowRadius = 5;
         cell.image.layer.shadowOpacity = 0.5;
        
        return cell
        
    }
    
    
}
