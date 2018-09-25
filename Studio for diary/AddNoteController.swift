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
    
    //connection to DB class
    let dataManager = DBManager()
    
    let imagePicker = UIImagePickerController()
    
    //variables and outlets to be stored
    var address: String?
    var lat: Double?
    var lon: Double?
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var imgToSave: UIImageView!
    
    /*
    *After finished editing the textView datas are stored, just before moving back
    *to the tableView or mapView (depending by where the user comes from)
    */
    override func viewWillDisappear(_ animated: Bool) {
        
        if noteTextView.text != "Your new note here ...", noteTextView.text != "" {
            
            dataManager.singleEntry.comment = noteTextView.text ?? ""
            dataManager.singleEntry.date = getCurrentDate()
            dataManager.singleEntry.time = getCurrentTime()
            dataManager.singleEntry.address = address ?? ""
            dataManager.singleEntry.lat = lat ?? 0.0
            dataManager.singleEntry.lon = lon ?? 0.0
            dataManager.singleEntry.timeStamp = NSDate()
            dataManager.singleEntry.uID = uid!
            
            if imgToSave.image != nil {
                dataManager.singleEntry.img = imgToSave.image
            }
            dataManager.uploadData()
        }
    }
    //----------------------------------------------------------------------------------
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        self.navigationItem.title = getCurrentDate()
        noteTextView.delegate = self
        noteTextView.text = "Your new note here ..."
        noteTextView.textColor = UIColor.lightGray
    
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

}
