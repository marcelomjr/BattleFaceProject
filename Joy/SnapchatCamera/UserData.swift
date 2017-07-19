//
//  UserData.swift
//  SnapchatCamera
//
//  Created by Marcelo Martimiano Junior on 11/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class UserData
{
    public private(set) var username: String
    public private(set) var account: String
    public private(set) var name: String
    public private(set) var age: String
    
    init (username: String, account: String, name: String, age: String)
    {
        self.username = username
        self.account = account
        self.name = name
        self.age = age
    }
}
