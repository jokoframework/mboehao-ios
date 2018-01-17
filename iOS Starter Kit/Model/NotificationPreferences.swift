//
//  NotificationPreferences.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/17/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import Foundation

class NotificationPreferences: Encodable, Decodable {
    var taskSwitch: Bool = false
    var timeLabel: String = ""
    var time = DateComponents()
}
