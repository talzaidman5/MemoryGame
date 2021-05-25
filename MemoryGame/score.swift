//
//  Score.swift
//  MemoryGame
//
//  Created by bobo on 22/05/2021.
//  Copyright © 2021 Tal. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

class score : Codable{
    var name: String = ""
    var time: Int = 0
    var location : PlayerLocation
    
    init(time: Int, loc: PlayerLocation, name: String) {
        self.time = time
        self.location = loc
        self.name = name
    }
    
    func getTime()->Int{
        return self.time
    }
    
    func getLocation()->PlayerLocation{
        return self.location
    }
    
    func getName()->String{
        return self.name
    }
}
