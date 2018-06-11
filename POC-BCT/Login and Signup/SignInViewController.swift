//
//  SignInViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/11/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignInViewController: UIViewController{
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func SignInButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if(user == nil){
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription as! String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
           else if let user = user {
               // let uid = user.uid
               // let email = user.email
               // let photoURL = user.photoURL
            }
        }
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.present(loginVC, animated: true, completion: nil)
        
    }
    
    
}


