//
//  ViewController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/13/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    @IBAction func logInBtnPressed(_ sender: UIButton) {
        if isConnectedToInternet() {
            performSegue(withIdentifier: "goToSecondView", sender: self)
        } else {
            let alert = UIAlertController(title: "Ups", message: "No hay conexión a Internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}

