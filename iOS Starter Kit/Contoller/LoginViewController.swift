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
import GoogleSignIn
import SVProgressHUD
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginBoxConstraint: NSLayoutConstraint!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var fbButton: UIView!
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //createKeyboardObservers()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        setUpGoogleButton()
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.delegate = self
        facebookLoginButton.frame = CGRect(x: 0, y: 0, width: 312, height: 48)
        fbButton.addSubview(facebookLoginButton)
    }
    func setUpGoogleButton() {
        googleSignInButton.style = GIDSignInButtonStyle.wide
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.light
    }
    // MARK: Google Sing In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        loginWithCredentials(credentials: credential)
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Bye bye")
    }
    // MARK: Facebook Sing In
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Log out")
    }
    //swiftlint:disable:next line_length
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            loginWithCredentials(credentials: credential)
        }
    }
    func loginWithCredentials(credentials: AuthCredential) {
        SVProgressHUD.show()
        Auth.auth().signIn(with: credentials) { (_, error) in
            if error == nil {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToSecondController", sender: nil)
            } else {
                self.presentAlertWithTitle(title: "Atención",
                                           message: "Hubo un problema al intentar acceder. Intente más",
                                           withOptions: true, options: "Ok",
                                           completion: { (_) in
                })
                SVProgressHUD.dismiss()
            }
        }
    }
    func createKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if notification.userInfo != nil {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                loginBoxConstraint.constant = keyboardSize.height
                view.setNeedsLayout()
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        loginBoxConstraint.constant = 145.5
        view.setNeedsLayout()
    }
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    @IBAction func logInBtnPressed(_ sender: UIButton) {
        performLogInWithEmailAndPassword()
    }
    func performLogInWithEmailAndPassword() {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField.text!,
                           password: passwordTextField.text!,
                           completion: { (_, error) in
            if error == nil {
                SVProgressHUD.dismiss()
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "goToSecondController", sender: self)
            } else {
                SVProgressHUD.dismiss()
                self.presentAlertWithTitle(title: "Atención",
                                           message: "Usuario o contraseña incorrecta",
                                           withOptions: true, options: "Ok",
                                           completion: { (_) in
                })
            }
        })
    }
    @IBAction func resetPasswordPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Resetear Contraseña",
                                      message: "Ingrese la direccion de email asociada a su cuenta",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "EMAIL"
        }
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            if let email = alert.textFields?.first?.text {
                print(email)
                Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                    if error == nil {
                        self.presentAlertWithTitle(title: "Exito!",
                            message: "Se envió un mail con instrucciones para resetear tu contraseña a \(email)",
                            withOptions: true, options: "Ok",
                            completion: { (_) in
                        })
                    } else {
                        self.presentAlertWithTitle(title: "Error",
                                                   // swiftlint:disable:next line_length
                                                   message: "Error al intentar resetear la contraseña. Verifique su email y vuelva a intentarlo",
                                                   withOptions: true, options: "Ok",
                                                   completion: { (_) in
                        })
                    }
                })
            } else {
                print("No hay email")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (_, error) in
            if error == nil {
                self.performLogInWithEmailAndPassword()
            } else {
                self.presentAlertWithTitle(title: "Error",
                                           message: "Hubo un error al intentar registrar un nuevo usuario",
                                           withOptions: true,
                                           options: "Ok",
                                           completion: { (_) in
                })
            }
        }
        SVProgressHUD.dismiss()
    }
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {}
}
