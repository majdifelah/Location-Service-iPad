//
//  MapViewViewController.swift
//  LocationsandMaps
//
//  Created by Majdi Felah on 20/06/2019.
//  Copyright © 2019 Majdi Felah. All rights reserved.
//

import UIKit
import MapKit

protocol CustomMapViewDelegate: class {
  func updateWithLocation(_ locationInfo: LocationInfo)
  func updateWithAnnotation(_ locations: [LocationInfo])
  
}

class MapViewViewController: UIViewController {
  
  weak var delegate: CustomMapViewDelegate?
  
  
  @IBOutlet var mapView: MKMapView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
      
    }
  
  
  

}



extension MapViewViewController: CustomMapViewDelegate {
  
  func updateWithAnnotation(_ locations: [LocationInfo]) {
    // remove old annotations -- remove all at once
    mapView.removeAnnotation(mapView?.annotations as! MKAnnotation)
    // create a new annotations
    
    // add annotations to map
    
  }
  
  
  func updateWithLocation(_ locationInfo: LocationInfo) {
    
    // get the coordinates
    guard let latitudeCoordinate = locationInfo.geometry.location.latitude else { return }
    guard let longitudeCoordinate = locationInfo.geometry.location.longitude else { return }
    
    let coordinate = CLLocationCoordinate2D(latitude: latitudeCoordinate, longitude: longitudeCoordinate)
    
    // make the region, with 1500m in either direction
    let mkRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
   
    // set region of map
    mapView.setRegion(mkRegion, animated: true)
    
    print("Map view has recieved \(locationInfo)" )
  }
  
}

extension MapViewViewController: MKMapViewDelegate {
  
}
