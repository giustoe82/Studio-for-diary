//
//  DBManager.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-16.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


protocol DataDelegate {
    func loadEntries()
    func loadDB()
}

protocol EntryDelegate {
    func setEntryData()
    //    func setRestData(description:[String:Any])
    //    func setRestImg(img:UIImage)
}

class DBManager {
    
    var dataDel: DataDelegate?
    var entryDel: EntryDelegate?
    
    let userID = Auth.auth().currentUser?.uid
    
    var EntriesArray:[Entry] = []
    var filteredEntries:[Entry] = []
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
                   
                    self.loadImage(imgUrl: self.singleEntry.imgUrl)
                    
                    self.EntriesArray.append(self.singleEntry)
                }
                self.EntriesArray.sort(by: { (lhs:Entry, rhs:Entry) -> Bool in
                    (lhs.timeStamp?.timeIntervalSince1970 ?? 0) > (rhs.timeStamp?.timeIntervalSince1970 ?? 0)
                })
                   self.dataDel?.loadEntries()
                    }
                }
                
        
                //self.loadThumbs()
            }
    
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
    
    func uploadImage(imgName: String) {
        if let image = singleEntry.img, let jpegData = image.jpegData(compressionQuality: 0.7) {
            let storageRef = Storage.storage().reference()
            let imgRef = storageRef.child(imgName + ".jpg")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imgRef.putData(jpegData, metadata: metadata) { (metadata, error) in
                guard metadata != nil else {
                    print(error!)
                    return
            }
            print("Image uploaded")
                
        }
    }
    
}
    
    func loadImage(imgUrl:String) {
        
        let storageRef =  Storage.storage().reference()
        let imgRef = storageRef.child(imgUrl)
        imgRef.getData(maxSize: 2048*2048) { data, error in
            if let error = error {
                print("\(error)")
            } else {
                if let imgData = data {
                    
                    if let myImg = UIImage(data: imgData) {
                        print("il file esiste")
                        self.singleEntry.img = myImg
                        
                    }
                }
            }
        }
    }
    
    

   /* func loadOne(restId:String) {
    let db = Firestore.firestore()
    let docRef = db.collection("Restaurants").document(restId)
    
    docRef.getDocument { (document, error) in
    if let error = error {
    print(error)
    }
    if let document = document, document.exists {
    if let dataDescription = document.data() {
    
    self.oneRestaurant.name = dataDescription["name"] as? String ?? ""
    self.oneRestaurant.adress = dataDescription["address"] as? String ?? ""
    self.oneRestaurant.imgUrl = dataDescription["img"] as? String ?? ""
    self.oneRestaurant.url = dataDescription["url"] as? String ?? ""
    self.oneRestaurant.tel = dataDescription["tel"] as? String ?? ""
    self.oneRestaurant.about = dataDescription["about"] as? String ?? ""
    
    self.loadImage(imgUrl: self.oneRestaurant.imgUrl )
    
    }
    } else {
    print("Document does not exist")
    }
    }
    }*/
    
   /* func loadThumbs() {
        let storageRef = Storage.storage().reference()
        for (index,var newRest) in restaurantArray.enumerated() {
            let imgRef = storageRef.child(newRest.thumbUrl )
            imgRef.getData(maxSize: 1024*1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    if let thumbData = data {
                        newRest.thumb = UIImage(data: thumbData)
                        self.restaurantArray[index] = newRest
                    }
                }
                self.dataDel?.laddaTabell()
            }
        }
    }*/
    
    
    /*func loadOne(restId:String) {
        let db = Firestore.firestore()
        let docRef = db.collection("Restaurants").document(restId)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print(error)
            }
            if let document = document, document.exists {
                if let dataDescription = document.data() {
                    
                    self.oneRestaurant.name = dataDescription["name"] as? String ?? ""
                    self.oneRestaurant.adress = dataDescription["address"] as? String ?? ""
                    self.oneRestaurant.imgUrl = dataDescription["img"] as? String ?? ""
                    self.oneRestaurant.url = dataDescription["url"] as? String ?? ""
                    self.oneRestaurant.tel = dataDescription["tel"] as? String ?? ""
                    self.oneRestaurant.about = dataDescription["about"] as? String ?? ""
                    
                    self.loadImage(imgUrl: self.oneRestaurant.imgUrl )
                    
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    */
   /* func loadImage(imgUrl:String) {
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child(imgUrl)
        imgRef.getData(maxSize: 1024*1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let imgData = data {
                    if let restImg = UIImage(data: imgData) {
                        self.oneRestaurant.img = restImg
                        self.restDel?.setRestData()
                    }
                }
            }
        }
    }*/
    
    /*func uploadData() {
        //var imgName = oneRestaurant.name.replacingOccurrences(of: " ", with: "_")
        //imgName = imgName.replacingOccurrences(of: "&", with: "")
        //imgName = imgName.lowercased()
        
        let db = Firestore.firestore()
        var dataDict = [
            "name": oneRestaurant.name,
            "address": oneRestaurant.adress,
            "tel": oneRestaurant.tel,
            "url": oneRestaurant.url,
            "about": oneRestaurant.about
        ]
        
        if oneRestaurant.img != nil {
            dataDict["img"] = imgName + ".jpg"
            dataDict["thumb"] = imgName + "_thumb.jpg"
        }
        
        db.collection("Restaurants").document().setData(dataDict) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Dokument sparat")
                if self.oneRestaurant.img != nil { self.uploadImage(imgName: imgName) }
            }
        }
    }*/
    
    
    /*func uploadImage(imgName:String) {
        if let image = oneRestaurant.img {
            
            UIGraphicsBeginImageContext(CGSize(width: 800, height: 475))
            let ratio = Double(image.size.width/image.size.height)
            let scaleWidth = 800.0
            let scaleHeight = 800.0/ratio
            let offsetX = 0.0
            let offsetY = (scaleHeight-475)/2.0
            image.draw(in: CGRect(x: -offsetX, y: offsetY, width: scaleWidth, height: scaleHeight))
            let largeImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let largeImg = largeImg, let jpegData = UIImageJPEGRepresentation(largeImg, 0.7) {
                let storageRef = Storage.storage().reference()
                let imgRef = storageRef.child(imgName+".jpg")
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                imgRef.putData(jpegData, metadata: metadata) { (metadata, error) in
                    guard metadata != nil else {
                        print(error!)
                        return
                    }
                    print("image uploaded")
                    self.uploadThumb(imgName: imgName)
                }
            }
        }
    }
    
    func uploadThumb(imgName:String) {
        if let image = oneRestaurant.img {
            UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
            let ratio = Double(image.size.width/image.size.height)
            let scaleWidth = ratio*80.0
            let scaleHeight = 80.0
            let offsetX = (scaleWidth-80)/2.0
            let offsetY = 0.0
            image.draw(in: CGRect(x: -offsetX, y: offsetY, width: scaleWidth, height: scaleHeight))
            
            let thumb = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let thumb = thumb, let jpegData = UIImageJPEGRepresentation(thumb, 0.7) {
                let storageRef = Storage.storage().reference()
                let imgRef = storageRef.child(imgName+"_thumb.jpg")
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                imgRef.putData(jpegData, metadata: metadata) { (metadata, error) in
                    guard metadata != nil else {
                        print(error!)
                        return
                    }
                    print("thumb uploaded")
                    //                    self.dataDel?.laddaDB()
                    //                    let alertController = UIAlertController(title:"Restaurangen sparad", message: "Gå tillbaka till förstasidan för att se resultatet", preferredStyle: .alert)
                    //                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    //                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}*/


}
