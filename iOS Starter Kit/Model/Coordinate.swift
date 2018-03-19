//
//  Coordinates.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 3/14/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import Foundation
import GoogleMaps
import SwiftyJSON

class Coordinate {
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var icon: String?
//    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        self.latitude = latitude
//        self.longitude = longitude
//    }
    init?(json: JSON) {
        self.latitude = json["latitude"].double!
        self.longitude = json["longitude"].double!
        self.icon = json["icon"].string!
    }
    func convertToCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
}
