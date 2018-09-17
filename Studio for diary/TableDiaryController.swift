//
//  TableDiaryController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-13.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit
import Firebase

class CustomCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    
}

class TableDiaryController: UITableViewController, DataDelegate {
    
    @IBOutlet var table: UITableView!
    
    
    var dataManager = DBManager()
    
    
    
    //@IBOutlet weak var loadActivity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.dataDel = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDB()
    }
    
    func loadEntries() {
        table.reloadData()
        //loadActivity.isHidden = true
    }
    
    func loadDB() {
        dataManager.EntriesArray.removeAll()
        //dataManager.sortedEntries.removeAll()
        dataManager.loadDB()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //return dataManager.sortedEntries.count
        return dataManager.EntriesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! CustomCell

        let row = indexPath.row
        table.rowHeight = 160
        
        //let entryCell = dataManager.sortedEntries[row]
        let entryCell = dataManager.EntriesArray[row]
        cell.dateLabel?.text = entryCell.date
        cell.timeLabel?.text = entryCell.time
        cell.commentLabel?.text = entryCell.comment
        cell.addressLabel?.text = entryCell.address

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            //dataManager.EntriesArray.remove(at: indexPath.row)
            
            
            table.reloadData()
            
            
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        try? Auth.auth().signOut()
        tabBarController?.dismiss(animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "uid")
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
