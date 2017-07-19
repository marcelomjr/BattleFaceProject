//
//  BattlesViewController.swift
//  SnapchatCamera
//
//  Created by Clara Carneiro on 7/6/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import Foundation
import UIKit

class BattlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var allTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    let photos = ["Face1", "Face2", "Face6", "Face4", "Face5", "Face6", "Face3"]
    let names = ["Clamacas", "Marcelo", "Clara", "Lucas", "Afonso", "Shakira", "Tyana"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let background = UIImage(named: "tabBar0")
        self.tabBarController?.tabBar.backgroundImage = background
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return names.count
    }
    
    @IBAction func switchSegment(_ sender: Any) {
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            allTableView.isHidden = false
            allTableView.reloadData()
        case 1:
            //            allTableView.isHidden = true
            allTableView.reloadData()
        case 2:
            //            allTableView.isHidden = true
            allTableView.reloadData()
        case 3:
            allTableView.isHidden = true
            allTableView.reloadData()
        default:
            print("Error")
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BattleTableViewCell", for: indexPath) as! BattleTableViewCell
        
        let random = Int(arc4random_uniform(UInt32(photos.count)))
        let random2 = Int(arc4random_uniform(UInt32(photos.count)))
        let random3 = Int(arc4random_uniform(UInt32(photos.count)))
        
        cell.hostPhoto.image = UIImage(named: (photos[random2]+".jpg"))
        cell.guestPhoto.image = UIImage(named: (photos[random]+".jpg"))
        cell.guestUsername.text = names[random]
        cell.hostUsername.text = names[random2]
        cell.judgeUsername.text = names[random3]
        
//        cell.hostPhoto.layer.cornerRadius = cell.hostPhoto.frame.size.width / 2
//        cell.hostPhoto.layer.masksToBounds = true
//        cell.guestPhoto.layer.cornerRadius = cell.guestPhoto.frame.size.width / 2
//        cell.guestPhoto.layer.masksToBounds = true
        
        
        return cell
    }

    
}
