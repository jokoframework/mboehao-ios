//
//  InternetConnection.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/29/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import Foundation
import Alamofire
import Firebase


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
    
    func logOutAlarm(controller: UITableViewController) {
        let alert = UIAlertController(title: "Log out", message: "Está seguro que desea salir?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
        }
        alert.addAction(cancelAction)
        let yesAction = UIAlertAction(title: "Si", style: .default) { _ in
            do{
                try Auth.auth().signOut()
                //self.performSegue(withIdentifier: "goToLoginView", sender: nil)
                controller.dismiss(animated: true, completion: nil)
            } catch{
                print("Error signing out")
            }
        }
        alert.addAction(yesAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func genericAlert(controller: UIViewController, message: String) {
        let alert = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
