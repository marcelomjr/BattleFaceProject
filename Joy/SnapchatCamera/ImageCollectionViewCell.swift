//
//  ImageCollectionViewCell.swift
//  SnapchatCamera
//
//  Created by Lucas Barros on 10/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        
    }
}
