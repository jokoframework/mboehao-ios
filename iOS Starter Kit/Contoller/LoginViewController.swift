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

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginBoxConstraint: NSLayoutConstraint!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createKeyboardObservers()
        
        //Background task mientras la aplicacion se encuentre activa.

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
    
    @IBAction func logInBtnPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error == nil {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToSecondController", sender: self)
            } else {
                SVProgressHUD.dismiss()
                self.presentAlertWithTitle(title: "Atención", message: "Usuario o contraseña incorrecta", withOptions: true, options: "Ok", completion: { (_) in
                })
            }
        })
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue){}
    
}

