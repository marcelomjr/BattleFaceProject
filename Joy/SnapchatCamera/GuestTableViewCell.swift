//
//  GuestTableViewCell.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 24/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class GuestTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePhotoImageView: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
