//
//  RegisterViewController.swift
//  SnapchatCamera
//
//  Created by Marcelo Martimiano Junior on 06/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class RegisterViewController: LoginViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // profile image
    @IBOutlet weak var avaImg: UIImageView!
    var profilePhotoData: Data?

    // textfields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet var fullnameTxt: UITextField!
    @IBOutlet var ageTxt: UITextField!

    // buttons
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!


    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!

    // reset default size
    var scrollViewHeight : CGFloat = 0

    // keyboard frame size
    var keyboard = CGRect()


    // default func
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // scrollview frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height

        // check notifications if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.hideKeybard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // declare hide kyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)

        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true

        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)

    }


    // call picker to select image
    func loadImg(_ recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }


    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        // Save the image to store it in Firebase
        if let photo = avaImg.image
        {
            self.profilePhotoData = UIImagePNGRepresentation(photo)
        }
        
        self.dismiss(animated: true, completion: nil)
    }


    // hide keyboard if tapped
    func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    

    // show keyboard
    func showKeyboard(_ notification:Notification) {

        // define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!

        // move up UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        })
    }


    // hide keyboard func
    func hideKeybard(_ notification:Notification) {

        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }



    // clicked sign up
    @IBAction func signUpBtn_click(_ sender: AnyObject) {
        print("sign up pressed")

        // dismiss keyboard
        self.view.endEditing(true)

        // if fields are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || ageTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty) {

            // alert message
            let alert = UIAlertController(title: "PLEASE", message: "fill all fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            print("field is empty")
            return
        }

        // send data to server to related collumns
        let email = self.emailTxt.text!
        let password = self.passwordTxt.text!
        let username = self.usernameTxt.text!
        let age = self.ageTxt.text!
        let name = self.fullnameTxt.text!
        
        
        FirebaseLib.signUp(account: email, password: password, username: username, name: name, age: age, profilePhotoData: self.profilePhotoData)
        { (error) in
            
            if error == nil
            {
                self.loginHandler(segueIdentifier: "RegisterToMainID")
            }
            else
            {
                // show alert message
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // clicked cancel
    @IBAction func cancelBtn_click(_ sender: AnyObject) {

        // hide keyboard when pressed cancel
        self.view.endEditing(true)

        self.dismiss(animated: true, completion: nil)
    }



}
