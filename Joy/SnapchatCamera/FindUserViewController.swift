//
//  FindUser.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 26/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class FindUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate
{
    var searchBarController = UISearchController()
    var resultsController = UITableViewController()
    var battle: Battle?
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    let usersDemo: [String] = [String]()
    var foundUsers: [String]?
    
    var findJudge: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Setup of search bar and search bar controller
        self.searchBarController = UISearchController(searchResultsController: resultsController)
        self.searchBarController.searchResultsUpdater = self
        self.searchBarController.searchBar.delegate = self
        self.searchBarController.hidesNavigationBarDuringPresentation = false
        
        
        // Setup of default table
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView = searchBarController.searchBar
        
        // Setup of results table
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.dataSource = self
        
        if (self.findJudge)
        {
            self.navigationController?.title = "Search and Select a Judge"
        }
        else
        {
            self.navigationController?.title = "Search and Select a Guest"
        }
    }
    
    func findUserStartingBy(key: String)
    {
        FirebaseLib.searchUser(path: "publicProfiles", key: key)
        { (error, usernames) in
            guard let users = usernames else
            {
                print("Error at search users")
                self.foundUsers = nil
                self.resultsController.tableView.reloadData()
                return
            }
            
            self.foundUsers = (users.allKeys as? [String])?.sorted()
            
            // reload the table
            self.resultsController.tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.resultsController.tableView
        {
            guard let usersNumber = self.foundUsers?.count else
            {
                print("Error at tableview numberofRows...")
                return 0
            }
            return usersNumber
        }
        else
        {
            return usersDemo.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()

        if tableView == self.resultsController.tableView
        {
            guard let users = self.foundUsers else
            {
                print("Error at tableview cellForRowAt...")
                cell.textLabel?.text = "Error"
                
                return cell
                
            }
            cell.textLabel?.text = users[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = usersDemo[indexPath.row]
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
            findUserStartingBy(key: text)
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tableViewTopConstraint.constant = -self.topLayoutGuide.length
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.tableViewTopConstraint.constant = +self.topLayoutGuide.length
    }

    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.resultsController.tableView
        {
            guard let user = self.foundUsers?[indexPath.row] else
            {
                print("username not found at didSelectRowAt")
                return
            }
            
            if (self.findJudge)
            {
                self.battle?.setJudge(username: user)
            }
            else
            {
                self.battle?.setGuest(username: user)
            }
            
        }
        
        self.searchBarController.isActive = false
        navigationController?.popViewController(animated: true)
    }
    
}
