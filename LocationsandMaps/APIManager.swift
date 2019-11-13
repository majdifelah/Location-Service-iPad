//
//  APIManager.swift
//  LocationsandMaps
//
//  Created by Majdi Felah on 20/06/2019.
//  Copyright © 2019 Majdi Felah. All rights reserved.
//

import Foundation
import CoreLocation

enum Outcome {
  case success(Data)
  case failure(String)
}

struct APIManager {
  
  private let session: URLSession
  
  init(session: URLSession = URLSession(configuration: .default)) {
    self.session = session
  }
  
  func searchFor(_ location: CLLocationCoordinate2D ,completion: @escaping (Outcome) -> Void) {
 
    
    let apiKey = "AIzaSyAw0m3prCKzqP-zrWauU7DsXJgMDnbQY-Y"
    let radius = "1000"
    let restaurant = "restaurant"
    let sensor = "false"
    
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "maps.googleapis.com"
    urlComponents.path = "/maps/api/place/textsearch/json"
    urlComponents.queryItems = [
      URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
      URLQueryItem(name: "radius", value: radius),
      URLQueryItem(name: "types", value: restaurant),
      URLQueryItem(name: "sensor", value: sensor),
      URLQueryItem(name: "key", value: apiKey)
    ]
    
    guard let searchURL = urlComponents.url else {
      completion(.failure("Unable to make URL"))
      return
    }
    
    let dataTask = session.dataTask(with: searchURL) { (data, response, error) in
      
      if let error = error {
        completion(.failure(error.localizedDescription))
      } else if let data = data, let response = response as? HTTPURLResponse {
        
        switch response.statusCode {
          
        case 200...299:
          completion(.success(data))
          
        default:
          completion(.failure("Response not in range 200-299"))
          
        }
        
      }
      
    }
    
    dataTask.resume()
    
  }
  
}
