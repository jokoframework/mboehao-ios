//
//  CellBodyViewController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/11/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit

class BodyViewController: UIViewController {
    
    var bodyText: String = ""
    @IBOutlet weak var bodyLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyLabel.text = bodyText
        // Do any additional setup after loading the view.
    }
    
    

}
