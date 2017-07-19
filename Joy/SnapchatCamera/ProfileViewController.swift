////
//  ProfileViewController.swift
//  SnapchatCamera
//
//  Created by Clara Carneiro on 7/6/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit

class ProfileViewController: UICollectionViewController
{
    


//    @IBOutlet weak var profilePhotoView: UIImageView!
//    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photoCollection: UICollectionView!
    var username: String?
    
    var collectionViewPhotos: [UIImage]?
    
//    var images = [ProfileImages]()
    var customImageFlowLayout: CustomImageFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.setProfilePhoto()
        self.collectionViewPhotos = [UIImage]()
        loadImages()
        customImageFlowLayout = CustomImageFlowLayout()
        photoCollection.collectionViewLayout = customImageFlowLayout
        photoCollection.backgroundColor = .white
        let data = FirebaseLib.getUserData(user: FirebaseLib.getUsername()!)
    }
    
    func loadImages()
    {
        print("load imagens")
        FirebaseLib.downloadUserPhotos
        { (userPhotos) in
            guard let photos = userPhotos else
            {
                print("Erro ao carregar as photos. in loadImages")
                return
            }
            self.collectionViewPhotos?.removeAll()
            for index in 0..<photos.count
            {
                self.collectionViewPhotos?.append(photos[index])
            }
            
            self.photoCollection.reloadData()
        }

        

    }

    @IBAction func reloadAction(_ sender: Any) {
        loadImages()
    }
    
    @IBAction func logOutAction(_ sender: Any)
    {
        Log.logOut()
        print("realizou log Out")
        // voltar pra tela de login
        self.performSegue(withIdentifier: "ToLoginScreenID", sender: self)

    }
//
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionViewPhotos == nil
        {
            print("none photos")
            return(0)
        }
        
        return collectionViewPhotos!.count
    }

    override func collectionView(_ imageCollection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        let image = collectionViewPhotos?[indexPath.row]
        
        cell.imageView.image = image;
        
        return cell
    }
    
    // header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        
        header.activityIndicator.startAnimating()
        
            let userID = Log.getUserID()
            FirebaseLib.getUsernameFromUserID(userID: userID!, completionHandler:
                    { (username) in
        
                        if username != nil
                        {
                            FirebaseLib.getProfilePhoto(user: username!, completionHandler:
                                { (photo) in
                                    header.avaImg.image = photo
                                    header.activityIndicator.stopAnimating()
                            })
                        }
                })


        return header
    }
    
}
