//
//  MapViewController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-13.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var myMap: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = manager.location?.coordinate {
            
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            myMap.setRegion(region, animated: true)
            myMap.removeAnnotations(myMap.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your location"
            myMap.addAnnotation(annotation)
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        try? Auth.auth().signOut()
        tabBarController?.dismiss(animated: true, completion: nil)
    }
    
}
