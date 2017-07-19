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
        guard takenPhotoView.image != nil else
        {
            print("Photo does not exist!! (nil)")
            return
        }
        guard let photoData = UIImagePNGRepresentation(takenPhotoView.image!) else
        {
            print("Erro in convertion of image")
            return
        }
        FirebaseLib.addPhoto(photoData: photoData, completionHandler: {_ in })

        //self.dismiss(animated: true, completion: nil)

        performSegue(withIdentifier: "PhotoDestinationToProfile", sender: nil)
    }

    @IBAction func buildBattle(_ sender: Any)
    {
        performSegue(withIdentifier: "PhotoDestinationToInvitation", sender: nil)
        
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
//        if let photoData = imageData
//        {
//            guard let user = FirebaseLib.getUsername() else
//            {
//                print("User not found")
//                return
//            }
//        }

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
