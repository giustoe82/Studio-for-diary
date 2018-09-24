//
//  SingleEntryShowController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-20.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit
import MapKit

class SingleEntryShowController: UITableViewController, MKMapViewDelegate {

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var imageField: UIImageView!
    
    var getComment = String()
    var getAddress = String()
    var getDate = String()
    var getTime = String()
    var getLat = Double()
    var getLon = Double()
    var getImage = UIImage()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Details"
        dateTimeLabel.text = getDate + " at " + getTime
        commentLabel.text = getComment
        addressLabel.text = getAddress
        imageField.image = getImage
        print(getLat)
        
            
            let center = CLLocationCoordinate2D(latitude: getLat, longitude: getLon)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your location"
            map.addAnnotation(annotation)
        
    
    
    

    

}
}
