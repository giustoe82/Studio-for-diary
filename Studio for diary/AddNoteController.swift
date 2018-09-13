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
        
        var notes:[String]
        
        if let tempNotes = notesObject as? [String] {
            
            notes = tempNotes
            
            notes.append(noteTextView.text!)
            
        } else {
            
            notes = [noteTextView.text!]
        }
        
        UserDefaults.standard.set(notes, forKey: "notes")
    }
   
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
