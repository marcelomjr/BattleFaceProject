//
//  JudgeViewController.swift
//  SnapchatCamera
//
//  Created by Clara Carneiro on 7/6/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import Foundation
import UIKit

class JudgeViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var judgeSegmentControll: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let photos = ["Face1", "Face2", "Face3", "Face4", "Face5", "Face6", "Face7"]
    let names = ["Clamacas", "Marcelo", "Clara", "Lucas", "Afonso", "Shakira", "Tyana"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return names.count
    }
    
    @IBAction func switchSegment(_ sender: Any) {
    
    switch judgeSegmentControll.selectedSegmentIndex {
    case 0:
    tableView.isHidden = false
    tableView.reloadData()
    case 1:
    //            allTableView.isHidden = true
    tableView.reloadData()
    default:
    print("Error")
    }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "JudgeTableViewCell", for: indexPath) as! JudgeTableViewCell
    
    let random = Int(arc4random_uniform(UInt32(photos.count)))
    let random2 = Int(arc4random_uniform(UInt32(photos.count)))
    let random3 = Int(arc4random_uniform(UInt32(photos.count)))
//            let randomTrue = Int(arc4random_uniform(1))
    
    cell.hostPhoto.image = UIImage(named: (photos[random2]+".jpg"))
    cell.guestPhoto.image = UIImage(named: (photos[random]+".jpg"))
    cell.guestUsername.text = names[random]
    cell.hostUsername.text = names[random2]
    cell.judgeUsername.text = names[random3]
    cell.guestWin.isHidden = false
    cell.hostWin.isHidden = true
    
//    cell.hostPhoto.layer.cornerRadius = cell.hostPhoto.frame.size.width / 2
//    cell.hostPhoto.layer.masksToBounds = true
//    cell.guestPhoto.layer.cornerRadius = cell.guestPhoto.frame.size.width / 2
//    cell.guestPhoto.layer.masksToBounds = true
    
    
    return cell
    }
}
