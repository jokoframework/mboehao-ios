//
//  PreferencesController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/4/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit

class PreferencesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMVC(_ sender: UIBarButtonItem) {
        //performSegue(withIdentifier: "goToMainVC", sender: self)
        self.dismiss(animated: true, completion: nil)
    }
}
