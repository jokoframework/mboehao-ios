//
//  SecondViewController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/14/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController {

    
    @IBOutlet weak var openSideMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openSideMenu.target = self.revealViewController()
        openSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        revealViewController().rearViewRevealWidth = 300
        
        DispatchQueue.main.async {
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounterLabel), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func updateCounterLabel(){
        print("\(Int(counterLabel.text!)! + 1)")
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue){}

}
