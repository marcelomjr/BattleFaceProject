//
//  ChallengedInvitationTableViewController.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 24/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class InvitationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate //UISearchBarDelegate
{
    var titles = ["Clara", "Lucas", "Marcelo"]
    
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
 //       createSearchBar()
    }
    
    func createSearchBar()
    {
//        self.searchController.searchBar.placeholder = "Find a friend to challenge!"
//        self.searchController.searchBar.setShowsCancelButton(true, animated: true)
//        self.searchBar = self.searchController.searchBar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestCell", for: indexPath) as! GuestTableViewCell
        cell.profilePhotoImageView.image = UIImage(named: "Face1")
        cell.usernameLabel.text = titles[indexPath.row]
        
        return cell
        
    }
    
}
