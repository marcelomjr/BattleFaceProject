//
//  ImageViewController.swift
//  BattleFace
//
//  Created by Clara Carneiro on 7/25/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

var cellImage = UIImage()

class ImageViewController: UIViewController {


    @IBOutlet var Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // title label at the top
        self.navigationItem.title = "Photo"
        self.navigationItem.leftBarButtonItem?.title = "Profile"
        self.Image.image = cellImage
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
