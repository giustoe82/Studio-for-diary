//
//  AddNoteController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-13.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class AddNoteController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let dataManager = DBManager()
    
    let imagePicker = UIImagePickerController()
    
    var address: String?
    var lat: Double?
    var lon: Double?
    
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var imgToSave: UIImageView!
    
        
    override func viewWillDisappear(_ animated: Bool) {
        
        if noteTextView.text != "Your new note here ...", noteTextView.text != "" {
    
        let db = Firestore.firestore()
            
        var dataDict: [String: Any] = [
            
            "date": getCurrentDate() ,
            "time": getCurrentTime() ,
            "comment": noteTextView.text ?? "",
            "timestamp": NSDate(),
            "address": address as Any,
            "lat": lat ?? 0.0,
            "lon": lon ?? 0.0,
            "uID": uid!
        ]
            let imgName = imgNameFromDate(time: NSDate()).replacingOccurrences(of: " ", with: "_")
            
            if imgToSave.image != nil {
                dataDict["img"] = imgName + ".jpg"
                
            }
        
        
        db.collection("Entries").document().setData(dataDict) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                
                print("Dokument sparat")
                
                if self.imgToSave.image != nil {
                    
                    self.uploadImage(imgName: imgName)
                }
            }
        }
    
        }
        
    }
    func uploadImage(imgName: String) {
        
        if let image = imgToSave.image, let jpegData = image.jpegData(compressionQuality: 0.7) {
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
    
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        //let imagePicker = UIImagePickerController()
        //imagePicker.delegate = self
        
        
        
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
    
    
   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        self.navigationItem.title = getCurrentDate()
        noteTextView.delegate = self
        noteTextView.text = "Your new note here ..."
        noteTextView.textColor = UIColor.lightGray
        
       
    }
    
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
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
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgToSave.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    /*func getTimeStamp() -> String {
        let formatter = DateFormatter()
        let now = Date()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
