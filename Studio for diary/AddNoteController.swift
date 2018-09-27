//
//  AddNoteController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi, Aleks Edholm, Aleksander Frostelén on 2018-09-23.
//  Copyright © 2018 Group g. All rights reserved.
//



import UIKit
import Firebase
import CoreLocation

class AddNoteController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var doneButton: UINavigationItem!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var imgToSave: UIImageView!
    
    //the struct that will contain the info to be saved in database
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
    
    //connection to DB class
    let dataManager = DBManager()
    
    let imagePicker = UIImagePickerController()
    
    //variables and outlets to be stored in case the entry contains coordinates
    var myAddress: String?
    var myLat: Double?
    var myLon: Double?
    
    let uid = Auth.auth().currentUser?.uid
    
   
    
    //Preparing the data to be saved in the struct
    @IBAction func saveButton(_ sender: Any) {
        if noteTextView.text != "Your new note here ...", noteTextView.text != "" {
            doneButton.hidesBackButton = true
            singleEntry.comment = noteTextView.text ?? ""
            singleEntry.date = getCurrentDate()
            singleEntry.time = getCurrentTime()
            singleEntry.address = myAddress ?? ""
            singleEntry.lat = myLat ?? 0.0
            singleEntry.lon = myLon ?? 0.0
            singleEntry.timeStamp = NSDate()
            singleEntry.uID = uid!
            
            if imgToSave.image != nil {
                singleEntry.img = imgToSave.image
            }
            
            uploadData()
            noteTextView.text = "Saving data ..."
            noteTextView.isEditable = false
            noteTextView.textColor = UIColor.red
            
            
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.hidesBackButton = false
        
        imagePicker.delegate = self
        self.navigationItem.title = getCurrentDate()
        noteTextView.delegate = self
        noteTextView.text = "Your new note here ..."
        noteTextView.textColor = UIColor.lightGray
        noteTextView.isEditable = true
    
    }
    
    /*
     *Fake placeholder text for the textView
     */
    func textViewDidBeginEditing(_ noteTextView: UITextView) {
        if noteTextView.textColor == UIColor.lightGray {
            noteTextView.text = ""
            noteTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ noteTextView: UITextView) {
        if noteTextView.text.isEmpty {
            noteTextView.text = "Your new note here ..."
            noteTextView.textColor = UIColor.lightGray
        }
    }
    //---------------------------------------------------------------
    
    /*
     *Keyboard behaviour
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    //---------------------------------------------------------------
    
    
    /*
     *Camera related functions
     */
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgToSave.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    //----------------------------------------------------------------------------
    
    /*
     *Getting Date and Time for view title and to be stored in database
     */
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
    
    
    /*
     Functions to save data in database:
     - general data for firestore
     - image to storage
     - thumbnail to storage
     */
    func uploadData() {
        
        var imgName = imgNameFromDate(time: NSDate()).replacingOccurrences(of: " ", with: "_")
        imgName = imgName.replacingOccurrences(of: ",", with: "_")
        imgName = imgName.replacingOccurrences(of: "-", with: "_")
        imgName = imgName.replacingOccurrences(of: ":", with: "")
        
        let db = Firestore.firestore()
        
        var dataDict: [String: Any] = [
            "date": singleEntry.date ,
            "time": singleEntry.time ,
            "comment": singleEntry.comment,
            "timestamp": singleEntry.timeStamp!,
            "address": singleEntry.address,
            "lat": singleEntry.lat ?? 0.0,
            "lon": singleEntry.lon ?? 0.0,
            "uID": singleEntry.uID
        ]
        
        if singleEntry.img != nil {
            dataDict["img"] = imgName + ".jpg"
            dataDict["thumb"] = imgName + "_thumb.jpg"
        }
        
        
        db.collection("Entries").document().setData(dataDict) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Entry uploaded in database")
                if self.singleEntry.img != nil {
                    self.uploadImage(imgName: imgName)
                } else {
                    self.doneButton.hidesBackButton = false
                    self.noteTextView.text = "Entry saved! Go back"
                    self.noteTextView.textColor = UIColor.green
                    self.noteTextView.isEditable = false
                }
            }
        }
    }
    
    func uploadImage(imgName: String) {
        
        if let image = singleEntry.img  {
            
            UIGraphicsBeginImageContext(CGSize(width: 288, height: 150))
            let ratio = Double(image.size.width/image.size.height)
            let scaleWidth = 288.0
            let scaleHeight = 288.0/ratio
            let offsetX = 0.0
            let offsetY = (scaleHeight-150)/2.0
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            let largeImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let largeImg = largeImg, let jpegData = largeImg.jpegData(compressionQuality: 0.7) {
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
        if let image = singleEntry.img {
            UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
            let ratio = Double(image.size.width/image.size.height)
            let scaleWidth = ratio*80.0
            let scaleHeight = 80.0
            let offsetX = (scaleWidth-80)/2.0
            let offsetY = 0.0
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            
            let thumb = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let thumb = thumb, let jpegData = thumb.jpegData(compressionQuality: 0.7) {
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
                    
                    self.doneButton.hidesBackButton = false
                    self.noteTextView.text = "Entry saved! Go back"
                    self.noteTextView.textColor = UIColor.green
                    self.noteTextView.allowsEditingTextAttributes = false
                }
            }
        }
    }
    
    //Function to assign a name to the picture taken
    func imgNameFromDate(time: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        let str = formatter.string(from: NSDate() as Date)
        return str
    }

}
