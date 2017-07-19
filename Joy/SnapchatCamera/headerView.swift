//
//  headerView.swift
//  BattleFace
//
//  Created by Clara Carneiro on 7/17/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit



class headerView: UICollectionReusableView {
    
    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    
    @IBOutlet weak var battles: UILabel!
    @IBOutlet weak var victories: UILabel!
    @IBOutlet weak var judgements: UILabel!
    
    @IBOutlet weak var battlesTitle: UILabel!
    @IBOutlet weak var victoriesTitle: UILabel!
    @IBOutlet weak var judgementsTitle: UILabel!

    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
}
