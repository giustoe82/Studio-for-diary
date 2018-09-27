//
//  DBManager.swift
//  Studio for diary
//
//  Created by Marco Giustozzi, Aleks Edholm, Aleksander Frostelén on 2018-09-23.
//  Copyright © 2018 Group g. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

//PROTOCOL for TableDiaryController
protocol DataDelegate {
    func loadEntries()
    func loadDB()
}
//PROTOCOL for MediaViewController
protocol CollectionDelegate {
    func loadEntries()
    func loadDB()
}

protocol EntryDelegate {
    func loadDB()
    //    func setRestData(description:[String:Any])
    //    func setRestImg(img:UIImage)
}

class DBManager {
    
    
    
    //let addManager = AddNoteController()
    var dataDel: DataDelegate?
    var entryDel: EntryDelegate?
    var collDel: CollectionDelegate?
    
    let userID = Auth.auth().currentUser?.uid
    
    var EntriesArray:[Entry] = []
    var filteredEntries:[Entry] = []
    var collectionArray:[Entry] = []
    var entriesWithImage:[Entry] = []
    var imageNames:[String] = []
    var singleEntry = Entry()
    
    
    struct Entry {
        var id = ""
        var imgUrl = ""
        var img:UIImage?
        var thumbUrl = ""
        var thumb:UIImage?
        var comment = ""
        var date = ""
        var time = ""
        var lat:Double?
        var lon:Double?
        var address = ""
        var uID = ""
        var timeStamp:NSDate?
    }
    
    init() {
        
    }
    
    /*
     DATABASE: LOAD FUNCTIONS
     Fetching data from database: everything taken from firestore (all but pics) is stored in  structs which are grouped in an array. The array elements are ordered by the property timestamp present in each struct
     */
    func loadDB() {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("Entries").whereField("uID", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let qSnapshot = querySnapshot else {return}
                for document in qSnapshot.documents {
                    
                    self.singleEntry = Entry()
                    self.singleEntry.id = document.documentID
                    self.singleEntry.comment = document.data()["comment"] as? String ?? ""
                    self.singleEntry.date = document.data()["date"] as? String ?? ""
                    self.singleEntry.time = document.data()["time"] as? String ?? ""
                    self.singleEntry.address = document.data()["address"] as? String ?? ""
                    self.singleEntry.timeStamp = document.data()["timestamp"] as? NSDate
                    self.singleEntry.lat = document.data()["lat"] as? Double ?? nil
                    self.singleEntry.lon = document.data()["lon"] as? Double ?? nil
                    self.singleEntry.imgUrl = document.data()["img"] as? String ?? ""
                    self.singleEntry.thumbUrl = document.data()["thumb"] as? String ?? ""
                    
                    self.EntriesArray.append(self.singleEntry)
                    
                }
                self.EntriesArray.sort(by: { (lhs:Entry, rhs:Entry) -> Bool in
                    (lhs.timeStamp?.timeIntervalSince1970 ?? 0) > (rhs.timeStamp?.timeIntervalSince1970 ?? 0)
                    
                })
                self.loadThumbs()
                self.dataDel?.loadEntries()
                
            }
        }
    }
    
    //together with the structs we load the thumbs that are going to be shown in the tableView
    func loadThumbs() {
        let storageRef = Storage.storage().reference()
        for (index,var entry) in EntriesArray.enumerated() {
            let imgRef = storageRef.child(entry.thumbUrl)
            imgRef.getData(maxSize: 1024*1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    if let thumbData = data {
                        entry.thumb = UIImage(data: thumbData)
                        self.EntriesArray[index] = entry
                    }
                }
                self.dataDel?.loadEntries()
            }
        }
    }
    /*
     Fetching data from database as in loadDB() with the difference that we want to filter
     the EntriesArray and create another array with entries that contain photo data
     ... a lot of code for a small usage but we may need this for future implementations
     */
    func loadDBtoCollection() {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("Entries").whereField("uID", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let qSnapshot = querySnapshot else {return}
                for document in qSnapshot.documents {
                    
                    self.singleEntry = Entry()
                    self.singleEntry.id = document.documentID
                    self.singleEntry.comment = document.data()["comment"] as? String ?? ""
                    self.singleEntry.date = document.data()["date"] as? String ?? ""
                    self.singleEntry.time = document.data()["time"] as? String ?? ""
                    self.singleEntry.address = document.data()["address"] as? String ?? ""
                    self.singleEntry.timeStamp = document.data()["timestamp"] as? NSDate
                    self.singleEntry.lat = document.data()["lat"] as? Double ?? nil
                    self.singleEntry.lon = document.data()["lon"] as? Double ?? nil
                    self.singleEntry.imgUrl = document.data()["img"] as? String ?? ""
                    self.singleEntry.thumbUrl = document.data()["thumb"] as? String ?? ""
                    
                    self.collectionArray.append(self.singleEntry)
                    
                    if self.singleEntry.imgUrl != "" {
                        self.entriesWithImage.append(self.singleEntry)
                    }
                    
                    
                }
                self.collectionArray.sort(by: { (lhs:Entry, rhs:Entry) -> Bool in
                    (lhs.timeStamp?.timeIntervalSince1970 ?? 0) > (rhs.timeStamp?.timeIntervalSince1970 ?? 0)
                    
                })
                self.entriesWithImage.sort(by: { (lhs:Entry, rhs:Entry) -> Bool in
                    (lhs.timeStamp?.timeIntervalSince1970 ?? 0) > (rhs.timeStamp?.timeIntervalSince1970 ?? 0)
                    
                })
                self.collDel?.loadEntries()
                
            }
        }
    }
    
    //---------------------------------------------------------------------------------
    
    
    /*
     Deleting data from database and Storage
     */
    func deleteFromDB(position: Int) {
        let db = Firestore.firestore()
        let deleteID = EntriesArray[position].id
        db.collection("Entries").document(deleteID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func deleteImage(position: Int) {
        let storageRef = Storage.storage().reference()
        let imageId = EntriesArray[position].imgUrl
        let imageRef = storageRef.child(imageId)
        
        imageRef.delete { error in
            if let error = error {
                print(error)
            } else {
                print("Image Deleted")
            }
        }
    }
    
    func deleteThumb(position: Int) {
        let storageRef = Storage.storage().reference()
        let thumbId = EntriesArray[position].thumbUrl
        let thumbRef = storageRef.child(thumbId)
        
        thumbRef.delete { error in
            if let error = error {
                print(error)
            } else {
                print("Thumbnail Deleted")
            }
        }
    }
    
    //---------------------------------------------------------------------------------
    
   /* func loadImage(imgUrl:String)  {
        
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child(imgUrl)
        imgRef.getData(maxSize: 1024*1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let imgData = data {
                    
                    if let myImg = UIImage(data: imgData) {
                        
                        self.singleEntry.img = myImg
                        
                    }
                }
            }
        }
    }*/
    

/*
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let str = formatter.string(from: Date())
        return str
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let str = formatter.string(from: Date())
        return str
    }
    func imgNameFromDate(time: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        let str = formatter.string(from: NSDate() as Date)
        return str
    }
 */
}
