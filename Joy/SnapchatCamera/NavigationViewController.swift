//
//  NavigationViewController.swift
//  SnapchatCamera
//
//  Created by Clara Carneiro on 7/10/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color of title at the top in nav controller
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        
        // color of buttons in nav controller
        self.navigationBar.tintColor = .black
        
        let backgroundNB = UIImage(named: "naviBar.jpg")
        self.navigationBar.setBackgroundImage(backgroundNB, for: .default)
        
        // color of background of nav controller
//        self.navigationBar.barTintColor = UIColor(red: 25.0 / 255.0, green: 194.0 / 255.0, blue: 134.0 / 255.0, alpha: 1)
        
        // disable translucent
        self.navigationBar.isTranslucent = false

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
