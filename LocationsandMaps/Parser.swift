//
//  Parser.swift
//  LocationsandMaps
//
//  Created by Majdi Felah on 20/06/2019.
//  Copyright © 2019 Majdi Felah. All rights reserved.
//

import Foundation

struct JSONParser {
  
  static func parse<T>(_ data: Data, type: T.Type) throws -> T where T : Decodable {
    
    return try JSONDecoder().decode(type.self, from: data)
    
  }
  
}

