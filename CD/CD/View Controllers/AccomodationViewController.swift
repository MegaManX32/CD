//
//  AccomodationViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 10/25/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import GoogleMaps

class AccomodationViewController: UIViewController {
    
    // MARK: - Properties 
    
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var descriptionTextView : UITextView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare google map with single pin
        self.setupMap()
        
        // update text view
        self.descriptionTextView.layer.masksToBounds = true
        self.descriptionTextView.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupMap() {
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        self.googleMapView.camera = camera;
        self.googleMapView.isMyLocationEnabled = true
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = self.googleMapView
    }
}
