//
//  TableDiaryController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-13.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit





class HeadlineTableWievCell : UITableViewCell {
    
    
}

class TableDiaryController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var notes:[String] = []
    var dates:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notesObject = UserDefaults.standard.object(forKey: "notes")
        let datesObject = UserDefaults.standard.object(forKey: "dates")
        
        if let tempNotes = notesObject as? [String], let tempDates = datesObject as? [String] {
            
            notes = tempNotes
            dates = tempDates
            
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let notesObject = UserDefaults.standard.object(forKey: "notes")
        let datesObject = UserDefaults.standard.object(forKey: "dates")
        
        if let tempNotes = notesObject as? [String], let tempDates = datesObject as? [String] {
            
            notes = tempNotes
            dates = tempDates
        }
        table.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = dates[indexPath.row]
        
        cell.detailTextLabel?.text = notes[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle , forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            notes.remove(at: indexPath.row)
            dates.remove(at: indexPath.row)
            
            table.reloadData()
            
            UserDefaults.standard.set(notes, forKey: "notes")
            UserDefaults.standard.set(dates, forKey: "dates")
            
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
