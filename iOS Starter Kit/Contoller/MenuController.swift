//
//  MenuController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/3/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit
import Firebase

class MenuController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                let alarm = AlarmController()
                alarm.logOutAlarm(controller: self)
                //performSegue(withIdentifier: "goToLoginView", sender: nil)
            }
        }
    }
    
    func performLogOut(){
        
    }
}
