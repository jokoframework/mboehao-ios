//
//  SecondViewController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/14/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var openSideMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
//        openSideMenu.target = self.revealViewController()
//        openSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
//
        if self.revealViewController() != nil {
            self.openSideMenu.target = self.revealViewController()
            self.openSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 200
        }
        
        
//        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
//        edgePan.edges = .left
//
//        view.addGestureRecognizer(edgePan)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
//        if recognizer.state == .recognized {
//            performSegue(withIdentifier: "sideMenuSegue", sender: self)
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
