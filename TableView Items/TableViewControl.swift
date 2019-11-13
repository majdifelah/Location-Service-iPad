//
//  TableViewController.swift
//  LocationsandMaps
//
//  Created by Majdi Felah on 20/06/2019.
//  Copyright © 2019 Majdi Felah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TableViewControl: UITableViewController {
  
  weak var delegate: CustomMapViewDelegate?
  
  var map = MapViewViewController()
  
  let apiManager = APIManager()
  var lastAnnot: MKPointAnnotation?
  let locationManager = CLLocationManager()
  let geocoder = CLGeocoder()
  
  var searchResults: [LocationInfo] = []
  
  @IBOutlet var searchBar: UISearchBar!
  
  func searchBarText() {
    
    guard let text = searchBar.text else { return }
    
    if text.caseInsensitiveCompare("?") == .orderedSame {
      reverseGeoCoding()
      return
    }
    
    let geoCoder = CLGeocoder()
    
    geoCoder.geocodeAddressString(text) { (placemarks, error) in
      
      guard let placemark = placemarks?.last,
        
        // make region
        let region = placemark.region as? CLCircularRegion,
        // get coordinates
        let coordinate = placemark.location?.coordinate else { return }
      
      let radius = (region.radius / 200.0) / 112.0
      let span = MKCoordinateSpan(latitudeDelta: radius, longitudeDelta: radius)
      let mkRegion = MKCoordinateRegion(center: coordinate, span: span)
      
      // make many points?
      let point = MKPointAnnotation()
      point.coordinate = region.center
      point.title = "Your Address"
      point.subtitle = "Last \(point.coordinate.latitude) - Long \(point.coordinate.longitude)"
      
      // set region of map
      self.map.mapView.setRegion(mkRegion, animated: true)
      if self.lastAnnot != nil {self.map.mapView.removeAnnotation(self.lastAnnot!)}
      self.lastAnnot = point
      self.map.mapView.addAnnotation(point)
    }
    
  }
  
  func reverseGeoCoding() {
    
    locationManager.delegate = self
    locationManager.requestLocation()
  }
  
  func forwardGeoCode(_ text: String) {
    
    geocoder.geocodeAddressString(text) { (placemarks, error) in
      
      if let error = error {
        print(error)
      } else if let placemarks = placemarks {
        print("Placemarks: \(placemarks)")
      }
      
    }
  }
  
  func search(_ text: String) {
    
    let geoCoder = CLGeocoder()
    
    geoCoder.geocodeAddressString(text) { (placemarks, error) in
      
      guard let placemark = placemarks?.last,
        
        let region = placemark.region as? CLCircularRegion,
        let coordinate = placemark.location?.coordinate else { return }
      
      self.apiManager.searchFor(coordinate) { [unowned self] outcome in
        
        switch outcome {
        case .failure(let errorString):
          print(errorString)
          
        case .success(let data):
          
          do {
            let result = try JSONParser.parse(data, type: Object.self)
            self.searchResults = result.results
            
            DispatchQueue.main.async {
              self.tableView.reloadData()
            }
            
          } catch {
            print("JSON Error: \(error)")
          }
          
        }
      }
    }
  }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      searchBar.delegate = self
      
      // retrieve a viewcontroller from a contrainer
      if let splitVC = splitViewController {
        
        for child in splitVC.viewControllers {
          
          if let myMapView = child as? MapViewViewController {
            delegate = myMapView
          }
        }
      }
      
      
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      locationManager.requestAlwaysAuthorization()
    }
    
  
  
    // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let currentResult = searchResults[indexPath.row]
    delegate?.updateWithLocation(currentResult)
  }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseID", for: indexPath)
      
      let currentResult = searchResults[indexPath.row]
      cell.textLabel?.text = currentResult.name
      
      return cell
    }
    
  }



extension TableViewControl: CLLocationManagerDelegate, MKMapViewDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
    
    guard let location = locations.last else { return }
    
    let geoCoder = CLGeocoder()
    
    geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
      
      if let placemark = placemarks?.first {
        
        print("You are at \(placemark)")
        
      } else if let error = error {
        
        print(error.localizedDescription)
        
      }
    }
  }
  
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
    
    print("location Manager Eror: \(error)")
    
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // print the new status i guess
  }
  
}// end of delegate

// MARK: - SearchBar Text
extension TableViewControl: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    guard let searchBartext = searchBar.text else { return }
    
    search(searchBartext)
    
  }
  
}



