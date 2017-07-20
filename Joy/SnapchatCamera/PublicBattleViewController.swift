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
        updataImage()
    }
    func updataImage()
    {
        self.activityIndicator.startAnimating()
        
        
        FirebaseLib.downloadImage(reference: "demo/lastPhoto/photo", completionHandler:
            {
                (error, photo) in
                guard photo != nil else
                {
                    print("Error in photo")
                    return
                }
                self.image.image = photo
                
                
                FirebaseLib.getDemoUser
                    {
                        (user) in
                        guard user != nil else
                        {
                            print("User not found!")
                            return
                        }
                        self.label.text = user
                }
                self.activityIndicator.stopAnimating()
        })
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updataImage()
//    }
}
