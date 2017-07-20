//
//  Invitation.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 19/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class InvitationViewController: UIViewController
{
    var takenPhoto: UIImage?
    @IBOutlet weak var takenPhotoView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard self.takenPhoto != nil else
        {
            print("Error while taking photo in Invitation View Controller!")
            return
        }
        self.takenPhotoView.image = self.takenPhoto
    }
    
    @IBAction func buildBattle(_ sender: Any)
    {
        self.saveThePhoto()
        performSegue(withIdentifier: "InvitationToTabBar", sender: nil)
    }
    func saveThePhoto()
    {
        guard let photoData = UIImagePNGRepresentation(self.takenPhotoView.image!) else
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
            if error != nil
            {
                print(error)
            }
        }

    }
    
    @IBAction func selectAGuest(_ sender: Any) {
    }
    @IBAction func selectAJudge(_ sender: Any) {
    }
    
    @IBAction func cancelButton(_ sender: Any)
    {
        performSegue(withIdentifier: "InvitationToTabBar", sender: nil)
    }
}
