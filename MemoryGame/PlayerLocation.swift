//
//  PlayerLocation.swift
//  MemoryGame
//
//  Created by bobo on 22/05/2021.
//  Copyright © 2021 Tal. All rights reserved.
//

import Foundation

class PlayerLocation : Codable{
    var lat: Double
    var lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon    }
    
    func getLat()->Double{
        return self.lat
    }
    
    func getLon()->Double{
        return self.lon
    }
}
