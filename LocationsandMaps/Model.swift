//
//  Model.swift
//  LocationsandMaps
//
//  Created by Majdi Felah on 20/06/2019.
//  Copyright © 2019 Majdi Felah. All rights reserved.
//

import Foundation


struct Object: Codable {
  
  var results: [LocationInfo]
  
}

struct LocationInfo: Codable {
  var geometry: Geometry
  var icon: String?
  var id: String?
  var name: String?
  var photos: [Photos]?
  var placeId: String?
  var plusCode: Pluscode
  var rating: Double?
  var reference: String?
  var scope: String?
  var types: [String]
  var userRatingsTotal: Int?
  var vicinity: String?
  
      enum CodingKeys: String, CodingKey {
          case placeId = "place_id"
          case plusCode = "plus_code"
          case geometry, icon, id, name, photos, reference, scope, types, vicinity, userRatingsTotal, rating
      }
  
}

struct Photos: Codable {
    var height: Int?
    var htmlAttributitons: String?
    var photoReference: String?
    var width: Int?

    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
        case height, htmlAttributitons, width
    }
}

struct Pluscode: Codable {
    var compoundCode: String
    var globalCode: String

    enum CodingKeys: String, CodingKey {

        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }

}

struct Geometry: Codable {
  var location: Location
  var viewport: Viewport
  
}

struct Location: Codable {
  var latitude: Double?
  var longitude: Double?
  
  enum CodingKeys: String, CodingKey {
    
    case latitude = "lat"
    case longitude = "lng"
  }
  
}

struct Viewport: Codable {
  var northeast: Northeast
  var southwest: Southwest
}

struct Northeast: Codable {
  var latitude: Double?
  var longitude: Double?
  
  enum CodingKeys: String, CodingKey {
    
    case latitude = "lat"
    case longitude = "lng"
  }
}

struct Southwest: Codable {
  var latitude: Double?
  var longitude: Double?
  
  enum CodingKeys: String, CodingKey {
    
    case latitude = "lat"
    case longitude = "lng"
  }
}
