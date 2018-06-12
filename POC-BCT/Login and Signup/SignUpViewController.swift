//
//  SignUpViewController.swift
//  POC-BCT
//
//  Created by Thivakkar Mahendran on 6/11/18.
//  Copyright © 2018 Thivakkar Mahendran. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpViewController: UIViewController{
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var password1TextField: UITextField!
    @IBOutlet var password2TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignupButton(_ sender: Any) {
        if((password1TextField.text == password2TextField.text) && (password1TextField.text != "") && (emailTextField.text != "")){
            Auth.auth().createUser(withEmail: emailTextField.text!, password: password2TextField.text!) { (authResult, error) in
                if(authResult != nil){
                   ///// navigate to the home screen
                    UserID = (authResult?.uid)!
                    
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! homeViewController
                    self.present(loginVC, animated: true, completion: nil)
                    
                }
                else{
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Check your email or password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func SigninButton(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signin") as! SignInViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
}
