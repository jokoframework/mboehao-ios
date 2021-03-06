//
//  Constants.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 3/12/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct UI {
        static let MainItem: Int = 0
        static let MapItem: Int = 1
        struct Colors {
            static let NavigationColor = UIColor(netHex: 0x3680F1)
            static let PrimaryColor = UIColor(netHex: 0x0069AF)
        }
        struct Size {
            static let StatusBar = UIApplication.shared.statusBarFrame.height
        }
    }
    struct URL {
        static let GithubAPI = "https://api.github.com/repos/googlesamples/android-architecture/issues"
        static let MapsURL: String = "comgooglemaps://"
        static func mapsURLDirections(latitude: Double, longitude: Double) -> NSURL {
            let url = NSURL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")!
            return url
        }
        static let PhoneURL = "tel://+59521603336"
    }
}
