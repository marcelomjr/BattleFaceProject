//
//  ProfileViewController.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 19/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit
class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    @IBOutlet weak var username: UINavigationItem!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var customImageFlowLayout: CustomImageFlowLayout!
    
    var images = [UIImage]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        profileSetup()
        
        self.photoCollection.delegate = self
        self.photoCollection.dataSource = self
        
        customImageFlowLayout = CustomImageFlowLayout()
        photoCollection.collectionViewLayout = customImageFlowLayout
        //photoCollection.backgroundColor = .white
    }
    func profileSetup()
    {
        self.username.title = FirebaseLib.getUsername()
        self.profilePhotoSetup()
        self.loadProfilePhoto()
    }
    func profilePhotoSetup()
    {
        // Configuration of UImageView
        self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.width / 2
        self.profilePhotoView.layer.masksToBounds = true
    }
    
    func loadProfilePhoto()
    {
        self.activityIndicator.startAnimating()
        FirebaseLib.getProfilePhoto(completionHandler:
            { (profilePhoto) in
                guard profilePhoto != nil else
                {
                    print("Error")
                    return
                }
                self.profilePhotoView.image = profilePhoto
                self.activityIndicator.stopAnimating()
        })
    }
    
    func loadImages()
    {
        print("load imagens")
    
        let im = UIImage(named: "WinColor")
        self.images.append(im!)
        
        self.photoCollection.reloadData()

    }

    @IBAction func reloadAction(_ sender: Any)
    {
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count
    }
    
    //
    func collectionView(_ imageCollection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        let image = images[indexPath.row]
        
        cell.imageView.image = image;
        
        return cell
    }
}
