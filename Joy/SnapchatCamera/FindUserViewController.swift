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
    
    
    //@IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var userSearchController = UserSearchController()
    var recentUsers =  [UserSearchResult]()
    
    // Array with the list of found users of search
    var foundUsers = [UserSearchResult]()
    
    let usersDemo: [String] = [String]()
    
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
        // Create a nib with the cell
        let nib = UINib(nibName: "UserTableViewCell", bundle: nil)
        // Register the cell identifier to reuse after
        self.resultsController.tableView.register(nib, forCellReuseIdentifier: "userCell")
    }
    
    func findUserStartingBy(key: String)
    {
        self.userSearchController.findUser(key: key)
        { (foundUsers) in
            if foundUsers == nil
            {
                print("trata nao achar usuario")
            }
            else
            {
                self.foundUsers = foundUsers!
                //            // reload the table
                            self.resultsController.tableView.reloadData()// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>VEJA SE FAZ SENTIDO
            }
            
        }
    }

    // Define the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.resultsController.tableView
        {
            return self.foundUsers.count
        }
        else
        {
            return recentUsers.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // TableView carregada por conta da pesquisa feita
        if tableView == self.resultsController.tableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
            cell.nameLabel.text = self.foundUsers[indexPath.row].name
            cell.usernameLabel.text = self.foundUsers[indexPath.row].username
            cell.profileImageView.image = self.foundUsers[indexPath.row].profilePhoto
            
            return cell
        }
        else
        {
            let cell = UITableViewCell()
            //cell.textLabel?.text =  self.foundUsers?[indexPath.row]
            return cell
           
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
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
        
        self.topConstraint.constant = -self.topLayoutGuide.length
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.topConstraint.constant = +self.topLayoutGuide.length
    }

    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.resultsController.tableView
        {
            let user = self.foundUsers[indexPath.row].username!
            
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
