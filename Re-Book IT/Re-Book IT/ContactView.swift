//
//  ContactView.swift
//  Re-Book IT
//
//  Created by Remy vandebosch on 30/08/18.
//  Copyright © 2018 Remy vandebosch. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

class ContactView: UIViewController{
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyCqQQICacPlh6oc5Hh0nAJZvoQQ7pLZrVs")
    }
    
    func loadMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 50.9255981, longitude: 5.3909875, zoom: 15.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -50.9255981, longitude: 5.3909875)
        marker.title = Constants.markerTitle
        marker.map = mapView
    }
}
