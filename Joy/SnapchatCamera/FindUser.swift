//
//  FindUser.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 26/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class FindUser: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate
{
    var searchBarController = UISearchController()
    var resultsController = UITableViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let usersDemo = ["Lucas","Clara","Marcelo"]
    var usernames: [String]?
    
    var defaultTableView: Bool = true // bool to indicate if is to use de default table view
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.searchBarController = UISearchController(searchResultsController: resultsController)
        self.searchBarController.searchResultsUpdater = self
        self.searchBarController.searchBar.delegate = self
        self.searchBarController.hidesNavigationBarDuringPresentation = false
        
        
        self.tableView.tableHeaderView = searchBarController.searchBar
        
        
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.dataSource = self
        

        
    }
    func findUserStartingBy(key: String)
    {
        FirebaseLib.searchUser(path: "publicProfiles", key: key)
        { (error, foundUsers) in
            guard let users = foundUsers else
            {
                print("Error at search users")
                self.usernames = nil
                self.resultsController.tableView.reloadData()
                return
            }
            
            self.usernames = (foundUsers!.allKeys as? [String])?.sorted()
            self.resultsController.tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if defaultTableView
        {
            return usersDemo.count
        }
        else
        {
            guard let usersNumber = usernames?.count else
            {
                print("Error at tableview numberofRows...")
                return 0
            }
            return usersNumber
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()

        if defaultTableView
        {
            cell.textLabel?.text = usersDemo[indexPath.row]
        }
        
        else
        {
            guard let users = usernames else
            {
                print("Error at tableview cellForRowAt...")
                return cell
                
            }
            cell.textLabel?.text = users[indexPath.row]
        }
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "guestCell", for: indexPath)
        
        
        return cell
    }
    
    
    public func updateSearchResults(for searchController: UISearchController)
    {
        guard let text = self.searchBarController.searchBar.text else
        {
            print("Error at updateSearchResults")
            return
        }
        if text.characters.count > 0
        {
            self.defaultTableView = false
            findUserStartingBy(key: text)
        }
        // Search bar is empty
        else
        {
            // Show the default table view
            self.defaultTableView = true
            self.tableView.reloadData()
        }
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tableViewTopConstraint.constant = -self.topLayoutGuide.length
        
        print("comecouuu")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.tableViewTopConstraint.constant = +self.topLayoutGuide.length
       
        print("acabouuu")
    }

    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
}
