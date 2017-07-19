//
//  LoginScreenViewController.swift
//  SnapchatCamera
//
//  Created by Marcelo Martimiano Junior on 04/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class LoginScreenViewController: LoginViewController
{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet var logoImg: UIImageView!
    // textfield
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    // buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!

    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(LoginScreenViewController.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "background.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }
    
    
    // hide keyboard func
    func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // clicked sign in button
    @IBAction func signInBtn_click(_ sender: AnyObject) {
        print("sign in pressed")
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            // show alert message
            let alert = UIAlertController(title: "Please", message: "fill in fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        // login functions
        let email = self.emailTxt.text!
        let password = self.passwordTxt.text!
        
        FirebaseLib.signIn(account: email, password: password)
        { (errorDescription) in
            
            if errorDescription == nil
            {
                self.loginHandler(segueIdentifier: "LoginScreenToMainID")
            }
            else
            {
                // show alert message
                let alert = UIAlertController(title: "Error", message: errorDescription!, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
}
