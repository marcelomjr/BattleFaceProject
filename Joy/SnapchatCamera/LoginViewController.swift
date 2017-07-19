//
//  LoginViewController.swift
//  SnapchatCamera
//
//  Created by Clara Carneiro on 7/7/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
{
    func loginHandler(segueIdentifier: String)
    {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
        print("Realizou Login (LoginViewController)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }


    
}
