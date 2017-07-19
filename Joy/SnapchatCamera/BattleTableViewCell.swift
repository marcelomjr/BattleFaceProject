//
//  BattleTableViewCell.swift
//  BattleFace
//
//  Created by Lucas Barros on 14/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class BattleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hostPhoto: UIImageView!
    @IBOutlet weak var guestPhoto: UIImageView!
    @IBOutlet weak var judgeUsername: UILabel!
    @IBOutlet weak var hostUsername: UILabel!
    @IBOutlet weak var guestUsername: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
