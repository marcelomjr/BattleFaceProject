//
//  PhotoDestination.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 14/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class PhotoDestinationViewController: UIViewController
{
    
    @IBOutlet weak var takenPhotoView: UIImageView!
    var takenPhoto: UIImage?

    @IBAction func postButton(_ sender: Any)
    {

        uploadPhoto()
        
        performSegue(withIdentifier: "PhotoDestinationToTabBar", sender: nil)
    }

    @IBAction func buildBattle(_ sender: Any)
    {
       
        
        guard let photoData = UIImagePNGRepresentation(self.takenPhotoView.image!) else
        {
            print("Error in convertion")
            return
        }
        FirebaseLib.demo(photoData: photoData)
        
         performSegue(withIdentifier: "PhotoDestinationToTabBar", sender: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard self.takenPhoto != nil else
        {
            print("Error while taking photo!")
            return
        }
        
        self.takenPhotoView.image = self.takenPhoto
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func uploadPhoto()
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
            else if error != nil
            {
                print("erro nao nulo")
            }
            else
            {
                print("erro nulo")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "PhotoDestinationToInvitation"
        {
            let invitationViewController = segue.destination as? InvitationViewController
            
            guard invitationViewController != nil else
            {
                print("Error fetching InvitationViewController!")
                return
            }
            guard self.takenPhoto != nil else
            {
                print("Error fetching photo!")
                return
            }
            invitationViewController!.takenPhoto = self.takenPhotoView.image
        }
    }

}
