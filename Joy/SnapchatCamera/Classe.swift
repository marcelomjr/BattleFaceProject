//
//  Classe.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 25/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class Classe: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating
{
    @IBOutlet weak var guestsTableView: UITableView!
    var resultsController = UITableViewController()
    var searchController = UISearchController()
    var titles = ["Clara", "Lucas", "Marcelo"]

    @IBOutlet weak var TableViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchBar.delegate = self
        
        //self.searchBar = self.searchController.searchBar
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.guestsTableView.tableHeaderView = self.searchController.searchBar
        
        
    }
    public func updateSearchResults(for searchController: UISearchController)
    {
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestCell", for: indexPath) as! GuestTableViewCell
        cell.profilePhotoImageView.image = UIImage(named: "Face1")
        cell.usernameLabel.text = titles[indexPath.row]
        
        return cell

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        self.TableViewTopConstraint.constant = 0
        print("começou")
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        print("acabou")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        print("cancelou")
    }



    
}
