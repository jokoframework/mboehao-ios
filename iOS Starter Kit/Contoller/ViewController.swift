//
//  ViewController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/13/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginBoxConstraint: NSLayoutConstraint!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let alarm = AlarmController()
        alarm.checkInternetConnectivity(controller: self)
        createKeyboardObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if notification.userInfo != nil {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                loginBoxConstraint.constant = keyboardSize.height
                view.setNeedsLayout()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        loginBoxConstraint.constant = 145.5
        view.setNeedsLayout()
    }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
//    func chechInternetConnectivity() {
//        let reachabilityManager = NetworkReachabilityManager()
//
//        reachabilityManager?.startListening()
//        reachabilityManager?.listener = { _ in
//            if let isNetworkReachable = reachabilityManager?.isReachable, !isNetworkReachable {
//                let alert = UIAlertController(title: "Sin conexión a Internet", message: "Asegurese que su dispositivo esté conectado a Internet", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
//                    NSLog("The \"OK\" alert occured.")
//                }))
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
    
    
    @IBAction func logInBtnPressed(_ sender: UIButton) {
        if isConnectedToInternet() {
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error == nil {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goToSecondController", sender: self)
                }
                SVProgressHUD.dismiss()
            })
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue){}
    
}

