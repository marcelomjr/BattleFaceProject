//
//  Log.swift
//  SnapchatCamera
//
//  Created by Marcelo Martimiano Junior on 12/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class Log
{
    static func isLoggedIn() -> Bool
    {
        var logged = false
        
        // Returns the shared defaults object.
        let defaults = UserDefaults.standard
        
        // Checks whether the default exists
        if let status = defaults.string(forKey: "userID")
        {
            // Make sure that it is logged in
            if status != ""
            {
                logged = true
            }
        }
        // Create the default
        else
        {
            defaults.set("", forKey: "userID")
        }
        
        return logged
    }

    static func deviceLogIn(userID: String)
    {
        let defautls = UserDefaults.standard
        if let lastUserID = defautls.string(forKey: "userID")
        {
            if lastUserID != userID
            {
                FirebaseLib.getUsernameFromUserID(userID: userID, completionHandler:
                { (username) in
                    if let user = username
                    {
                        FirebaseLib.setUsername(username: user)
                    }
                })
                
                // carrega dados do novo usuário
                print("Trocou de usuário")
            }
        }
        
        defautls.set(userID, forKey: "userID")
    }
    
    static func getUserID() -> String?
    {
        var userID: String?
        let defautls = UserDefaults.standard
        if let uid = defautls.string(forKey: "userID")
        {
            userID = uid
        }
        return userID
    }
    
    static func logOut()
    {
        let defautls = UserDefaults.standard
        
        defautls.set("", forKey: "userID")
    }
}
