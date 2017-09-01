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
    var finalUsernames = [String]()
    var finalNames = [String]()
    
    enum SearchType
    {
        case Judge, Guest
    }

    // Pesquisa por nome ou username e retorna uma lista de elementos com: Nome, username e foto de perfil.
    func findUser(key: String, battle: Battle, searchType: SearchType, completionHandler: @escaping ([UserSearchResult]?)->Void)
    {
        var results = [UserSearchResult]()
        let endValueKey = self.getEndValueKey(key: key)
        
        var type = "usernamesTable"
        FirebaseLib.searchUser(typeOfSearch: type , key: key, endValueKey: endValueKey)
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
            FirebaseLib.searchUser(typeOfSearch: type, key: key, endValueKey: endValueKey, completionHandler:
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
                
                self.finalUsernames = self.usernames!.allKeys as! [String]
                self.finalNames = self.usernames!.allValues as! [String]
                
                self.removeInconsistencies(battle: battle, searchType: searchType)
                
                for index in 0 ..< self.finalUsernames.count
                {
                    results.append(UserSearchResult())
                    results[index].username = self.finalUsernames[index]
                    results[index].name = self.finalNames[index]
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
            // Copia todos os resultados para o dicionário usernames.
            self.usernames = NSDictionary(objects: names, forKeys: foundUsernames as [NSCopying])
            return
        }
        let rightUsernames = self.usernames?.allKeys as! [String]
        
        
        for index in 0 ..< foundUsernames.count
        {
            let user = foundUsernames[index]
            
            // Se o usuario nao esta na lista coloque ele nela
            if !rightUsernames.contains(user)
            {
                self.usernames?.setValue(names[index], forKey: foundUsernames[index])
            }
        }
    }
    
    func getProfilePhoto(username: String, completionHandler: @escaping (UIImage?, Error?) -> Void)
    {
        let photoPath = "userPhotos/" + username + "/profilePhoto.jpg"
        
        FirebaseLib.downloadImage(reference: photoPath)
        { (photo, error) in
            
            DispatchQueue.main.async
            {
                completionHandler(photo, error)
            }
            
        }
    }
    
    func removeInconsistencies(battle: Battle, searchType: SearchType)
    {
        // Retira o próprio usuário da lista
            let host = battle.hostUsername
            
        if let index = self.finalUsernames.index(of: host)
        {
            self.finalUsernames.remove(at: index)
            self.finalNames.remove(at: index)
        }
        
        // Se já foi selecionado um juiz nao permite que ele seja selecionado novamente como guest.
        if (searchType == .Guest)
        {
            // Se nao existe judge registrado nao precisa verificar
            guard battle.judgeUsername != nil else
            {
                return
            }
            
            let judge = battle.judgeUsername!
                
            if let index = self.finalUsernames.index(of: judge)
            {
                self.finalUsernames.remove(at: index)
                self.finalNames.remove(at: index)
            }
        }
        // Somente pode ser judge o type
        else
        {
            // Se nao existe guest registrado nao precisa verificar
            guard battle.guestUsername != nil else
            {
                return
            }
            
            let guest = battle.guestUsername!
            
            if let index = self.finalUsernames.index(of: guest)
            {
                self.finalUsernames.remove(at: index)
                self.finalNames.remove(at: index)
            }

        }
        
    }
    
    func getEndValueKey(key: String) -> String
    {
        let lastChar = key.unicodeScalars.last!
        let nextChar = String(Character(UnicodeScalar(lastChar.value + 1)!))
        var endValue = key
        
        endValue.append(nextChar)
        let index = endValue.endIndex
        
        endValue.remove(at: endValue.index(index, offsetBy: -2))
        return endValue
    }
}





