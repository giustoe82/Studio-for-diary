//
//  MediaViewController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi, Aleks Edholm, Aleksander Frostelén on 2018-09-23.
//  Copyright © 2018 Group g. All rights reserved.
//

import UIKit
import Firebase

class MediaCustomCell: UICollectionViewCell {
   
    @IBOutlet weak var imageCell: UIImageView!
    
}

private let reuseIdentifier = "mediaCell"



class MediaViewController: UICollectionViewController, UINavigationControllerDelegate, CollectionDelegate {
    
    
    @IBOutlet var collectionGallery: UICollectionView!
    
    //connection to database class
    var dataManager = DBManager()
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadDB()
        loadEntries()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        dataManager.collDel = self
        //loadDB()
        //loadEntries()
        
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataManager.entriesWithImage.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MediaCustomCell
        
       let name = dataManager.entriesWithImage[indexPath.item].imgUrl
        
        loadImage(imgUrl: name, cell: cell)
        
        return cell
    }
    
    //this function is here only to make the protocol in DBManager work
    func loadEntries() {
        collectionGallery.reloadData()
    }
    //this function is here only to make the protocol in DBManager work
    func loadDB() {
        dataManager.collectionArray.removeAll()
        dataManager.entriesWithImage.removeAll()
        dataManager.loadDBtoCollection()
    }

    
    func loadImage(imgUrl:String, cell: MediaCustomCell)  {
        
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child(imgUrl)
        imgRef.getData(maxSize: 1024*1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let imgData = data {
                    
                    if let myImg = UIImage(data: imgData) {
                        
                        cell.imageCell.image = myImg
                        
                    }
                }
            }
        }
    }
    
    //setup for the image to be shown fullscreen
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Svc = Storyboard.instantiateViewController(withIdentifier: "ShowFullScreenController") as! ShowFullScreenController
        
        Svc.getFullImage = dataManager.entriesWithImage[indexPath.item].imgUrl
        
        self.navigationController?.pushViewController(Svc, animated: true)
        
    }
    
    
    

    /*
     LOG OUT
     */
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.logOut()
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
   
    
    func logOut() {
        try? Auth.auth().signOut()
        tabBarController?.dismiss(animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "uid")
    }
    @IBAction func logOut(_ sender: Any) {
        displayAlert(title: "Logging Out", message: "Do you want to Log Out?")
        
    }
    
}

