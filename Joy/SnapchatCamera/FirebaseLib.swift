//
//  Challenge.swift
//  SnapchatCamera
//
//  Created by Marcelo Martimiano Junior on 09/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class FirebaseLib
{
    static private var username: String?
    
    static func editProfilePhoto(user: String, photoData: Data)
    {
        var path = "userPhotos/" + user + "/profilePhoto.jpg"
        self.storePhoto(reference: path, photoData: photoData)
        
    }
    
   
    static func addPhoto(photoData: Data, completionHandler: @escaping (String?, String?) -> Void)
    {
        guard let user = self.username else
        {
            print("Username not found in this device!")
            return
        }
        var ref: DatabaseReference!
        ref = Database.database().reference()

        print("esta em addPhoto")
        let numPhotosPath = "photosNumber"
        self.getUserValue(path: numPhotosPath)
        { (numPhotos) in
            guard let number = numPhotos else
            {
                DispatchQueue.main.async
                {
                        completionHandler(nil, "Error in the photosNumber")
                }
                return
            }
            
            DispatchQueue.main.async
            {
                let photoPath = "userPhotos/" + user + "/photo" + number
                self.storePhoto(reference: photoPath, photoData: photoData)
                // Increment the number of photos
                let newNumber = Int(number)! + 1
                let totalNumber = "\(newNumber)"
                ref.child("usersData/" + user + "/photosNumber").setValue(totalNumber)
                ref.child("usersData").child(user).child("photos").childByAutoId().setValue(photoPath)
                print("numero de fotos" + totalNumber)
                completionHandler(photoPath, nil)

            }
        }
    }
    
    static func storePhoto(reference: String, photoData: Data)
    {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference as the path of image tha will be saved
        let imageRef = storageRef.child(reference)
        
        print("vai tentar subir")
        // Upload the file to the path
        imageRef.putData(photoData, metadata: nil)
        { (metadata, error) in
            guard let metadata = metadata else
            {
                print("Erro")
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
            print(downloadURL)
        }
    }
    static func getProfilePhoto(completionHandler: @escaping (Error?, UIImage?) -> Void)
    {
        guard let user = self.username else
        {
            print("Username not found in this device!")
            return
        }
        
        let path = "userPhotos/" + user + "/profilePhoto.jpg"
        
        self.downloadImage(reference: path)
        {
            (error, profilePhoto) in
            
            DispatchQueue.main.async
                {
                    guard profilePhoto != nil else
                    {
                        guard error != nil else
                        {
                            // Error while convert Data to UIImage
                            completionHandler(nil, nil)
                            return
                        }
                        // Error while get image
                        completionHandler(error, nil)
                        return
                        
                    }
                    // Profile photo is taken with sucess
                    completionHandler(nil, profilePhoto)
            }
        }
        
    }
    
    /* This function downloads a photo from the server
     * Returns a image or nil if there is an error
     */
    static func downloadImage(reference: String, completionHandler: @escaping (Error?, UIImage?) -> Void)
    {

        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference with an initial file path and name
        //let pathReference = storage.reference(withPath: "images/stars.jpg")
        
        // Create a reference to the file you want to download
        let imageRef = storageRef.child(reference)
    
        // Download in memory with a maximum allowed size of 20 MB
        imageRef.getData(maxSize: 20 * 1024 * 1024)
        {
            data, error in
            DispatchQueue.main.async
            {
                // Get the error if it exists
                guard error == nil else
                {
                    print("Error while get the photo, in downloadImage")
                    completionHandler(error, nil)
                    return
                }
                // Try create the image
                guard let image = UIImage(data: data!) else
                {
                    print("Error creating image from data")
                    completionHandler(nil, nil)
                    return
                }
                completionHandler(nil, image)
            }
        }
    }
    
    static func getPhotosPath(completionHandler: @escaping (Error?, [String]?) -> Void)
    {
        // Verify user.
        guard let user = self.getUsername() else
        {
            completionHandler(nil, nil)
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // Download of all photo's reference.
        ref.child("usersData").child(user).child("photos").observeSingleEvent(of: .value, with:
        { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let photosRef = value?.allValues as? [String]
            
            // Test array of references
            guard var photosPath = photosRef else
            {
                print("Error! Photo's path not found")
                return
            }
            
            photosPath = photosPath.sorted()
            completionHandler(nil, photosPath)
            
        })
        { (error) in
            completionHandler(error, nil)
        }
    }
    
    static func getUsernameFromUserID(userID: String, completionHandler: @escaping (String?) -> Void)
    {
        var ref: DatabaseReference!
        ref = Database.database().reference()

        ref.child("usersTable").child(userID).observeSingleEvent(of: .value, with:
            { (snapshot) in
                let value = snapshot.value as? String
                
                DispatchQueue.main.async
                    {
                        let username = value
                        completionHandler(username)
                }
        })
    }
    
    static func getUserValue(path:String, completionHandler: @escaping (String?) -> Void)
    {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        if let user = username
        {
            ref.child("usersData").child(user).child(path).observeSingleEvent(of: .value, with:
                { (snapshot) in
                    let value = snapshot.value as? String
                
                    DispatchQueue.main.async
                    {
                            let data = value
                            completionHandler(data)
                    }
            })
        }
    }

    
    
    static func getUserData(completionHandler: @escaping (UserData?) -> Void)
    {
        
        guard let user = self.getUsername() else
        {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("usersData").child(user).observeSingleEvent(of: .value, with:
        {
            (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            let account = value?["account"] as? String ?? ""
            let name = value?["name"] as? String ?? ""
            let age = value?["age"] as? String ?? ""
            
            var userData: UserData? = UserData(username: user, account: account, name: name, age: age)
    
            DispatchQueue.main.async
            {
                completionHandler(userData)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func createUser(account: String, password: String, completionHandler: @escaping (String?, String) -> Void)
    {
        Auth.auth().createUser(withEmail: account, password: password) { (user, error) in
            if user != nil
            {
                print("register ok")
                DispatchQueue.main.async
                {
                    let userID = user!.uid
                    // Mensagem de erro nil
                    completionHandler(error?.localizedDescription, userID)
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    // Mensagem de erro
                    completionHandler(error?.localizedDescription, "")
                }
                
                print("Sign up error")
            }
        }
    }
    
    static func signUp(account: String, password: String, username: String, name: String, age: String, profilePhotoData: Data?,
                             completionHandler: @escaping (String?) -> Void)
    {
        var error: String?
        // verifica se a conta e o username já não existem!!!!!!!!!!!!!!!!!
        
        self.createUser(account: account, password: password)
        {(signUpError, userID) in
            
            if signUpError == nil
            {
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                
                let user =  ref.child("usersData").child(username)
                if user != nil///////////MELHORARAR ISSSOO
                {
                    user.child("account").setValue(account)
                    user.child("name").setValue(name)
                    user.child("age").setValue(age)
                    user.child("photosNumber").setValue("0")
                }
                
                
                // Set the userID in this device
                Log.deviceLogIn(userID: userID)
                
                let usersTable = ref.child("usersTable")

                if usersTable != nil
                {
                    usersTable.child(userID).setValue(username)
                }
                if (profilePhotoData != nil)
                {
                    
                    self.editProfilePhoto(user: username, photoData: profilePhotoData!)
                }
                
                DispatchQueue.main.async
                    {
                        // Error message
                        completionHandler(error)
                }

            }
            // Error in in createUser function
            else
            {
                DispatchQueue.main.async
                    {
                        // Mensagem de erro
                        completionHandler(signUpError)
                }
            }
            
            
            
        }
    }
    
    static func signIn(account: String, password: String, completionHandler: @escaping (String?)->Void)
    {
        Auth.auth().signIn(withEmail: account, password: password)
        { (user, error) in
            // LogIn ok
            if user != nil
            {
                DispatchQueue.main.async
                    {
                        Log.deviceLogIn(userID: user!.uid)
                        completionHandler(nil)
                }

            }
                
            else if error != nil
            {
                DispatchQueue.main.async
                    {
                        
                        completionHandler(error!.localizedDescription)
                }
            }
        }
    }
    
    static func setUsername(username: String)
    {
        self.username = username
    }
    
    static func getUsername() -> String?
    {
        if self.username != nil
        {
            guard let userID = Log.getUserID() else
            {
                print("User ID not found")
                return nil
            }
            self.getUsernameFromUserID(userID: userID, completionHandler:
            { (user) in
                self.username = user
            })
        }
        
        return self.username
    }
    
    static func buildBattle(challenged: String, judge: String, myPhotoPath: String,photoCaption: String)
    {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        guard let user = FirebaseLib.getUsername() else
        {
            print("Username not found!")
            return
        }
        
        let challenge = ref.child("challenges").childByAutoId()
        challenge.child("challenger").setValue(user)
        challenge.child("challenged").setValue(challenged)
        challenge.child("judge").setValue(judge)
        challenge.child("challengerPhotoPath").setValue(myPhotoPath)
    }
}
