//
//  SearchController.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 30/08/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class UserSearchController
{
    var nameAndUsernames: NSDictionary?
    var usernames: NSDictionary?
    
    // Pesquisa por nome ou username e retorna uma lista de elementos com: Nome, username e foto de perfil.
    func findUser(key: String, completionHandler: @escaping ([UserSearchResult]?)->Void)
    {
        var results = [UserSearchResult]()
        var type = "usernamesTable"
        FirebaseLib.searchUser(typeOfSearch: type , key: key)
        { (foundUsernames) in

            if foundUsernames == nil
            {
                self.usernames = nil
            }
            else
            {
                self.usernames = foundUsernames
            }
            
            type = "namesTable"
            FirebaseLib.searchUser(typeOfSearch: type, key: key, completionHandler:
            { (foundNames) in
                
                if foundNames == nil
                {
                    self.nameAndUsernames = nil
                }
                else
                {
                    self.nameAndUsernames = foundNames!
                    self.mergeList()
                }
                
                guard self.usernames != nil else
                {
                    print("nenhum mesmo foi achado")
                    completionHandler(nil)
                    return
                }
                
                let finalUsernames = self.usernames!.allKeys as! [String]
                let finalNames = self.usernames!.allValues as! [String]
                
                for index in 0 ..< finalUsernames.count
                {
                    let username = finalUsernames[index]
                    
//                    let photoPath = "userPhotos/" + username + "/profilePhoto.jpg"
//                    FirebaseLib.downloadImage(reference: photoPath, completionHandler:
//                    { (error, photo) in
//                        if photo != nil
//                        {
//                            results[index].profilePhoto = photo
//                        }
//                    })
                    
                    results.append(UserSearchResult())
                    results[index].username = username
                    results[index].name = finalNames[index]
                }
                
                completionHandler(results)
                
            })
        }
    }
    
    
    
    func mergeList()
    {
        // Caso nao tenha encontrado nenhum nome, basta apenas olhar os usernames
        guard self.nameAndUsernames != nil else
        {
            return
        }
        
        let names = self.nameAndUsernames?.allKeys as! [String]
        let foundUsernames = self.nameAndUsernames?.allValues as! [String]
        
        // Caso nao tenha sido encontrado usernames mas tenha sido encontrados nomes
        if self.usernames == nil
        {
            for index in 0 ..< names.count
            {
                self.usernames?.setValue(foundUsernames[index], forKey: names[index])
            }
            return
        }
        let rightUsernames = self.usernames?.allKeys as! [String]
        
        
        for index in 0 ..< foundUsernames.count
        {
            let user = foundUsernames[index]
            
            // Se o usuario nao esta na lista coloque ele nela
            if !rightUsernames.contains(user)
            {
                self.usernames?.setValue(foundUsernames[index], forKey: names[index])
            }
        }
    }
}
