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



class MediaViewController: UICollectionViewController, UINavigationControllerDelegate, DataDelegate {
    
    
    @IBOutlet var collectionGallery: UICollectionView!
    
    var dataManager = DBManager()
   // var imageNames:[String] = []
    var images:[UIImage] = []
    var myImage:UIImage? = nil
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadDB()
        loadEntries()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        dataManager.dataDel = self
        
        
        
        
       /* let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.width - 20)/2, height: self.collectionView.frame.height/3)
       */
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataManager.entriesWithImage.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MediaCustomCell
        
       let name = dataManager.entriesWithImage[indexPath.item].imgUrl
        
        loadImage(imgUrl: name, cell: cell)
        
        return cell
    }
    
    func loadEntries() {
        collectionGallery.reloadData()
    }
    
    func loadDB() {
        dataManager.EntriesArray.removeAll()
        dataManager.entriesWithImage.removeAll()
        dataManager.loadDB()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
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
}
