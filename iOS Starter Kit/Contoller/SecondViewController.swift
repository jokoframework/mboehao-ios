//
//  SecondViewController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/14/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import SVProgressHUD
import WebKit

class SecondViewController: UIViewController, WKUIDelegate {

    @IBOutlet var openSideMenu: UIBarButtonItem!
    var webView: WKWebView!
    
    //@IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let alarm = AlarmController()
        alarm.checkInternetConnectivity(controller: self)
        
        let url = URL(string: "https://github.com/jokoframework/mboehao-ios/blob/master/README.md")
        let request = URLRequest(url: url!)
        webView.load(request)
        
//        if self.revealViewController() != nil {
//            self.openSideMenu.target = self.revealViewController()
//            self.openSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            self.revealViewController().rearViewRevealWidth = 300
//        }
        
        openSideMenu.target = self.revealViewController()
        openSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        revealViewController().rearViewRevealWidth = 300
        
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func notifyPressed(_ sender: UIButton) {
//        timedNotification(inSeconds: 3) { (success) in
//            if success {
//                print("Success")
//            }
//        }
//    }
    
    func timedNotification(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Local Push Notification"
        content.subtitle = "Test"
        content.body = "Test of local push notification"
        
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
        
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue){}

}
