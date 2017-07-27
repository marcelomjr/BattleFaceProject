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
    
    @IBOutlet weak var takenPhotoImageView: UIImageView!
    var takenPhoto = UIImage()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.takenPhotoImageView.image = self.takenPhoto
    }
    
    func photoSetup()
    {
        
    }
    
    @IBAction func searchChallengedButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "InvitationToFindUser", sender: nil)
    }
    
    @IBAction func searchJudgeButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "InvitationToFindUser", sender: nil)
    }
}
