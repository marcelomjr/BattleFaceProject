//
//  ChallengedInvitationTableViewController.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 24/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class InvitationViewController: UIViewController
{
    @IBOutlet weak var judgeActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var judgeUsernameLabel: UILabel!
    
    @IBOutlet weak var judgeProfilePhoto: UIImageView!
    @IBOutlet weak var guestActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var guestUsernameLabel: UILabel!
    @IBOutlet weak var guestProfilePhoto: UIImageView!
    
    @IBOutlet weak var takenPhotoImageView: UIImageView!
    
    
    
    var takenPhoto = UIImage()
    var battle: Battle?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("viewDidLoad in InvitationViewController")
        self.takenPhotoImageView.image = self.takenPhoto
        
        guard let user = FirebaseLib.getUsername() else
        {
            print("Error in prepare segue of InvitationToFindUser")
            return
        }
        
        self.battle = Battle(hostUsername: user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUsers()
    }

    func updateUsers()
    {
        if let guest = battle?.guestUsername
        {
            self.guestUsernameLabel.text = guest
            if battle?.guestProfilePhoto == nil
            {
                self.guestActivityIndicator.startAnimating()
                
                // Get the user profile photo
                let guestPhotoPath = "userPhotos/" + guest + "/profilePhoto.jpg"
                FirebaseLib.downloadImage(reference: guestPhotoPath, completionHandler:
                { (error, profilePhoto) in
                    guard let photo = profilePhoto else
                    {
                        print("Error in load guest profile photo")
                        print(error!.localizedDescription)
                        return
                    }
                    self.battle?.setGuestProfilePhoto(photo: photo)
                    self.guestProfilePhoto.image = profilePhoto
                    self.guestActivityIndicator.stopAnimating()
                })
            }
            
        }
        if let judge = self.battle?.judgeUsername
        {
            self.judgeUsernameLabel.text = judge
            if battle?.judgeProfilePhoto == nil
            {
                self.judgeActivityIndicator.startAnimating()
                
                // Get the judge profile photo
                let judgePhotoPath = "userPhotos/" + judge + "/profilePhoto.jpg"
                
                FirebaseLib.downloadImage(reference: judgePhotoPath, completionHandler:
                { (error, profilePhoto) in
                    guard let photo = profilePhoto else
                    {
                        print("Error in load judge profile photo")
                        return
                    }
                    self.battle?.setJudgeProfilePhoto(photo: photo)
                    self.judgeProfilePhoto.image = photo
                    self.judgeActivityIndicator.stopAnimating()
                })
            }
        }
    }
    
    @IBAction func searchChallengedButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "InvitationToFindUser", sender: "guest")
        
    }
    
    @IBAction func searchJudgeButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "InvitationToFindUser", sender: "judge")
    }
    
    @IBAction func cancelButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "InvitationToBattles", sender: nil)
    }
    
    @IBAction func buildBattleButton(_ sender: Any)
    {
        // create battle
        self.uploadPhoto()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "InvitationToFindUser")
        {
            guard let key = sender as? String else
            {
                print("Error at prepare for segue at InvitationViewController")
                return
            }
            
            let findUserViewController = segue.destination as? FindUserViewController
            guard findUserViewController != nil else
            {
                print("Error in segue.destination")
                return
            }
            
            if key == "judge"
            {
                findUserViewController!.findJudge = true
            }
            else if key == "guest"
            {
                findUserViewController!.findJudge = false
            }
            else
            {
                print("sender not identified at prepare for segue")
            }
            
            // Add a reference to the battle
            findUserViewController!.battle = self.battle
            
        }
    }
    
    func uploadPhoto()
    {
        guard let photoData = UIImagePNGRepresentation(self.takenPhotoImageView.image!) else
        {
            print("Error in convertion")
            return
        }
        
        
        FirebaseLib.addPhoto(photoData: photoData)
        { (photoPath, error) in
            if photoPath != nil
            {
                // cria desafio
            }
            else if error != nil
            {
                print(error!)
            }
            else
            {
                print("erro nulo")
            }
        }
        
    }

}
