//
//  AddNoteController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-13.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit

class AddNoteController: UIViewController, UITextViewDelegate {
    
    

    @IBOutlet weak var noteTextView: UITextView!
    
    @IBAction func saveNote(_ sender: Any) {
        
        let notesObject = UserDefaults.standard.object(forKey: "notes")
        let datesObject = UserDefaults.standard.object(forKey: "dates")
        
        var notes:[String]
        var dates:[String]
        
        if noteTextView.text != "Your new note here ..." {
        
            if let tempNotes = notesObject as? [String], let tempDates = datesObject as? [String] {
            
            notes = tempNotes
            dates = tempDates
            
            notes.append(noteTextView.text!)
            dates.append(getCurrentDateTime())
            
        } else {
            
            notes = [noteTextView.text!]
            dates = [getCurrentDateTime()]
        }
        
        UserDefaults.standard.set(notes, forKey: "notes")
        UserDefaults.standard.set(dates, forKey: "dates")
        noteTextView.text = ""
    }
    }
   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.backBarButtonItem!.title = "Back"
        self.navigationItem.title = getCurrentDateTime()
        
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
    
    func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        //formatter.timeStyle = .short
        
        let str = formatter.string(from: Date())
        
        return str
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
