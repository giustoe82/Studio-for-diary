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

class AddNoteController: UIViewController, UITextViewDelegate {
    
    var address: String?
    var lat: Double?
    var lon: Double?
    
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var noteTextView: UITextView!
    
    
        
    override func viewDidDisappear(_ animated: Bool) {
        
        if noteTextView.text != "Your new note here ..." {
    
        let db = Firestore.firestore()
        
        let dataDict: [String: Any] = [
            "date": getCurrentDate() ,
            "time": getCurrentTime() ,
            "comment": noteTextView.text ?? "",
            "timestamp": NSDate(),
            "address": address as Any,
            "lat": lat ?? 0.0,
            "lon": lon ?? 0.0,
            "uID": uid!
        ]
        
        
        db.collection("Entries").document().setData(dataDict) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Dokument sparat")
            }
        }
    
        }
        
    }
   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
