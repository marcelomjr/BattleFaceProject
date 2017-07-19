//
//  PublicBattleViewController.swift
//  SnapchatCamera
//
//  Created by Clara Carneiro on 7/6/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import Foundation
import UIKit

class PublicBattlesViewController: UIViewController
{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func loadImage(_ sender: Any)
    {
        self.activityIndicator.startAnimating()

        let userID = Log.getUserID()
        FirebaseLib.getUsernameFromUserID(userID: userID!, completionHandler:
            { (username) in
                
            if username != nil
            {
                self.label.text = username
                
                
                FirebaseLib.getProfilePhoto(user: username!, completionHandler:
                    { (photo) in
                        self.image.image = photo
                        self.image.layer.masksToBounds = true
                        self.image.layer.borderWidth = 0
                        self.image.layer.cornerRadius = self.image.frame.size.width / 2
                        self.activityIndicator.stopAnimating()

                })
            }
        })
    }
}
