//
//  TableDiaryController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-13.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

//Layout of each cell in tableView
class CustomCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageInTable: UIImageView!
    
}

/*
 This class regulates the tableView where the user can see all the entries ordered by the time
 the note has been taken.
 */
class TableDiaryController: UITableViewController, DataDelegate,  UISearchBarDelegate, CLLocationManagerDelegate  {
    
    
    
    
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var locationManager = CLLocationManager()
    
    var dataManager = DBManager()
    //This boolean var defines if the search field is active or not and therefore it defines
    //from which array we fetch datas
    var isSearching = false
    
    
    
    
    //@IBOutlet weak var loadActivity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.dataDel = self
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //maybe it will work with a protocol in mapview????
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDB()
        //loadEntries()
    }
    
    func loadEntries() {
        table.reloadData()
        //loadActivity.isHidden = true
    }
    
    func loadDB() {
        dataManager.EntriesArray.removeAll()
        dataManager.filteredEntries.removeAll()
        dataManager.loadDB()
    }
    

    // MARK: - Table view data source
    
    //Here we decide the number of sections in tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Here we decide by how many cells the tableView will be composed of
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == false {
        return dataManager.EntriesArray.count
        } else {
            return dataManager.filteredEntries.count
        }
    }

    //Here we set up the content of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! CustomCell

        let row = indexPath.row
        table.rowHeight = 160
        
        if isSearching == false {
        let entryCell = dataManager.EntriesArray[row]
            cell.dateLabel?.text = entryCell.date
            cell.timeLabel?.text = entryCell.time
            cell.commentLabel?.text = entryCell.comment
            cell.addressLabel?.text = entryCell.address
            cell.imageInTable.image = entryCell.img
            } else {
            let entryCell = dataManager.filteredEntries[row]
            cell.dateLabel?.text = entryCell.date
            cell.timeLabel?.text = entryCell.time
            cell.commentLabel?.text = entryCell.comment
            cell.addressLabel?.text = entryCell.address
            cell.imageInTable.image = entryCell.img
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            table.reloadData()
        } else {
            isSearching = true
            
            dataManager.filteredEntries = dataManager.EntriesArray.filter { $0.comment.localizedCaseInsensitiveContains( searchText ) ||
                $0.date.localizedCaseInsensitiveContains( searchText )
            }
            
            table.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    //Here we select the cell fields that are going to be sended to the detail view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Svc = Storyboard.instantiateViewController(withIdentifier: "SingleEntryShowController") as! SingleEntryShowController
        if isSearching == false {
        Svc.getComment = dataManager.EntriesArray[indexPath.row].comment 
        Svc.getAddress = dataManager.EntriesArray[indexPath.row].address
        Svc.getDate = dataManager.EntriesArray[indexPath.row].date
        Svc.getTime = dataManager.EntriesArray[indexPath.row].time
        Svc.getLat = dataManager.EntriesArray[indexPath.row].lat ?? 0.0
        Svc.getLon = dataManager.EntriesArray[indexPath.row].lon ?? 0.0
            if dataManager.EntriesArray[indexPath.row].img != nil {
                Svc.getImage = dataManager.EntriesArray[indexPath.row].img!
            }
        } else {
            Svc.getComment = dataManager.filteredEntries[indexPath.row].comment
            Svc.getAddress = dataManager.filteredEntries[indexPath.row].address
            Svc.getDate = dataManager.filteredEntries[indexPath.row].date
            Svc.getTime = dataManager.filteredEntries[indexPath.row].time
            Svc.getLat = dataManager.filteredEntries[indexPath.row].lat ?? 0.0
            Svc.getLon = dataManager.filteredEntries[indexPath.row].lon ?? 0.0
            if dataManager.filteredEntries[indexPath.row].img != nil {
            Svc.getImage = dataManager.filteredEntries[indexPath.row].img!
            }
        }
        self.navigationController?.pushViewController(Svc, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            dataManager.deleteFromDB(position: indexPath.row)
            
            dataManager.EntriesArray.remove(at: indexPath.row)
            
            table.reloadData()
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        manager.requestLocation()
    }
    
    
    /*func loadImage(imgUrl:String) {
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child(imgUrl)
        imgRef.getData(maxSize: 1024*1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let imgData = data {
                    if let myImage = UIImage(data: imgData) {
                        self.dataManager.singleEntry.img = myImage
                        
                    }
                }
            }
        }
    }*/
    
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
