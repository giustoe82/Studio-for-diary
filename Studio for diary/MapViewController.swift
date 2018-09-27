//
//  MapViewController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi, Aleks Edholm, Aleksander Frostelén on 2018-09-23.
//  Copyright © 2018 Group g. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //variables that will compose the address string
    var thoroughfare = ""
    var subThoroughfare = ""
    var subAdministritiveArea = ""

    @IBOutlet weak var myMap: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var address = ""
    //variables that will be used in SingleEntryShowController to create the annotation
    //in that mapView
    var lat:Double?
    var lon:Double?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = manager.location?.coordinate {
            locationManager.stopUpdatingLocation()
            //fetching actual coordinates
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            myMap.setRegion(region, animated: true)
            myMap.removeAnnotations(myMap.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your location"
            myMap.addAnnotation(annotation)
            
            let userLocation =  CLLocation(latitude: center.latitude, longitude: center.longitude)
            
            //Creating the address string
            CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if error != nil {
                    print(error!)
                } else {
                    
                    if let placemark = placemarks?[0] {
                        
                        var thoroughfare = ""
                        if placemark.thoroughfare != nil {
                            thoroughfare = placemark.thoroughfare!
                            self.address += thoroughfare + " "
                        }
                        
                        var subThoroughfare = ""
                        if placemark.subThoroughfare != nil {
                            subThoroughfare = placemark.subThoroughfare!
                            self.address += subThoroughfare + " "
                        }
                        
                        var subAdministritiveArea = ""
                        if placemark.subAdministrativeArea != nil {
                            subAdministritiveArea = placemark.subAdministrativeArea!
                            self.address += subAdministritiveArea + " "
                        }
                        
                        var country = ""
                        if placemark.country != nil {
                            country = placemark.country!
                            self.address += country
                        }
                        
                    }
                    
                }
                self.lat = coord.latitude
                self.lon = coord.longitude
                print(self.lat!)
                
            }
            
        }
    }
    
    
    //adding coordinates and address when the user creates a new entry from this view
    @IBAction func toNote(_ sender: Any) {
        self.performSegue(withIdentifier: "toNotes", sender: address)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddNoteController {
            let vc = segue.destination as? AddNoteController
            vc?.myAddress = address
            vc?.myLat = lat
            vc?.myLon = lon
        }
    }
    
    
    //in case there is an error when fetching user's position
 /*   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        manager.requestLocation()
    }*/
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        //resetting address string
        address = ""
    }
    
    /*
     LOG OUT
     */
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.logOut()
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logOut() {
        try? Auth.auth().signOut()
        tabBarController?.dismiss(animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "uid")
    }
    
    @IBAction func logOut(_ sender: Any) {
       displayAlert(title: "Logging Out", message: "Do you want to Log Out?")
    }
    
}
