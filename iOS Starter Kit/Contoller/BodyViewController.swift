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
    var issueTitle: String = ""
    
    
    @IBOutlet weak var bodyLabel: UITextView!
    @IBOutlet weak var titleLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = issueTitle
        bodyLabel.text = bodyText
        
        // Do any additional setup after loading the view.
    }
    
    

}
