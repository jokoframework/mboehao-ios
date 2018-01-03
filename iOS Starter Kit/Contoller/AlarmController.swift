//
//  InternetConnection.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/29/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import Foundation
import Alamofire

class AlarmController: UIViewController {

    func checkInternetConnectivity(controller: UIViewController) {
        
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { _ in
            let alert = UIAlertController(title: "Sin conexión a Internet", message: "Asegurese que su dispositivo esté conectado a Internet", preferredStyle: .alert)
            if let isNetworkReachable = reachabilityManager?.isReachable, !isNetworkReachable {
//                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
//                    NSLog("The \"OK\" alert occured.")
//                }))
                controller.show(alert, sender: self)
            } else {
                //controller.dismiss(animated: true, completion: nil)
            }
        }
    }
}
