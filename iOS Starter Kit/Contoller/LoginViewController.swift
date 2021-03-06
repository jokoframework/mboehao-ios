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
import LocalAuthentication
import SwiftKeychainWrapper
import NVActivityIndicatorView

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate {
    //Nuevos Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var fbButton: UIView!
    var loadingView: NVActivityIndicatorView?
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGoogleButton()
        setUpFacebookButton()
        //createKeyboardObservers()
        //Fijarse si el usuario no cerró sesión
        checkIfUserIsLogged()
        checkIfUserSetTouchID()
        //setUpTextField(emailTextField)
        //setUpTextField(passwordTextField)
    }
    func checkIfUserIsLogged() {
        if FBSDKAccessToken.current() != nil {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            loginWithCredentials(credentials: credential)
        } else {
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                GIDSignIn.sharedInstance().signIn()
            } else {
                print("no hay usuarios activos")
            }
        }
    }
    func checkIfUserSetTouchID() {
        if let state = UserDefaults.standard.value(forKey: "saveCredential") as? Bool, state == true {
            let context: LAContext = LAContext()
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                // swiftlint:disable:next line_length
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Necesitamos validar TouchID", reply: { (wasSuccessful, _) in
                    if wasSuccessful {
                        DispatchQueue.main.async {
                            self.emailTextField.text = KeychainWrapper.standard.string(forKey: "userEmailISK")
                            self.passwordTextField.text = KeychainWrapper.standard.string(forKey: "userPasswordISK")
                        }
                        self.performLogInWithEmailAndPassword()
                    } else {
                        let alert = UIAlertController(title: "Error",
                                                      message: "No se pudo verificar TouchID",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    func setUpTextField(_ textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.height - width,
                              width: textField.frame.width,
                              height: textField.frame.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    func setUpGoogleButton() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.light
    }
    func setUpFacebookButton() {
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.delegate = self
        facebookLoginButton.frame = CGRect(x: 0, y: 0, width: 239, height: 48)
        fbButton.addSubview(facebookLoginButton)
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
    }
    // MARK: Facebook Sing In
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    //swiftlint:disable:next line_length
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if result.isCancelled {
            print("No se aceptaron los permisos")
        } else {
            if error != nil {
                print("Error \(error)")
            } else {
                //swiftlint:disable:next line_length
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                loginWithCredentials(credentials: credential)
            }
        }
    }
    func loginWithCredentials(credentials: AuthCredential) {
        SVProgressHUD.show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //showLoading(true)
        Auth.auth().signIn(with: credentials) { (_, error) in
            if error == nil {
                SVProgressHUD.dismiss()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //self.showLoading(false)
                //self.performSegue(withIdentifier: "goToSecondController", sender: nil)
                self.segueToMainViewController()
            } else {
                self.presentAlertWithTitle(title: "Atención",
                                           message: "Hubo un problema al intentar acceder. Intente más",
                                           withOptions: true, options: "Ok",
                                           completion: { (_) in
                })
                SVProgressHUD.dismiss()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //self.showLoading(false)
            }
        }
    }
    // MARK: Keyboard Observers
    //Las funciones abajo comentadas pueden ser utiles en caso de que sea necesario
    //realizar alguna acción cuando el teclado aparece
    //Como por ejemplo mover un uiview hacia arriba para que el teclado no lo oculte.
    //También es necesario que el constraint que deseamos modificar sea un @IBOutlet
//    func createKeyboardObservers() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillShow(notification:)),
//                                               name: NSNotification.Name.UIKeyboardWillShow,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillHide(notification:)),
//                                               name: NSNotification.Name.UIKeyboardWillHide,
//                                               object: nil)
//    }
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if notification.userInfo != nil {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                myViewConstraint.constant = keyboardSize.height
//                view.setNeedsLayout()
//            }
//        }
//    }
//    @objc func keyboardWillHide(notification: NSNotification) {
//        myViewConstraint.constant = 145.5
//        view.setNeedsLayout()
//    }
    //Esta función detecta cuando se toca fuera de un textBox, y hace desaparecer el teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        self.passwordTextField.resignFirstResponder()
        performLogInWithEmailAndPassword()
    }
    func performLogInWithEmailAndPassword() {
        SVProgressHUD.show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Auth.auth().signIn(withEmail: emailTextField.text!,
                           password: passwordTextField.text!,
                           completion: { (_, error) in
            if error == nil {
                SVProgressHUD.dismiss()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let actionSheet = UIAlertController(title: "Acceder con TouchID",
                                                    message: "Desea utilizar TouchID para acceder en el futuro?",
                                                    preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Sí", style: .default, handler: { (_) in
                    //Validar touchID y luego guardar los datos
                    let context: LAContext = LAContext()
                    if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                        // swiftlint:disable:next line_length
                        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Necesitamos validar TouchID", reply: { (wasSuccessful, _) in
                            if wasSuccessful {
                                print("TouchID se validó correctamente")
                                //Si se pudo verificar TouchID entonces querémos guardar el mail
                                //y password del usuario para hacer login sólo con TouchID
                                self.saveInKeychain()
                                UserDefaults.standard.set(true, forKey: "saveCredential")
                            }
                            self.segueToMainViewController()
                        })
                    }
                    //self.passwordTextField.text = ""
                    //self.performSegue(withIdentifier: "goToSecondController", sender: self)
                    
                }))
                actionSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
                    UserDefaults.standard.set(false, forKey: "saveCredential")
                    //self.performSegue(withIdentifier: "goToSecondController", sender: self)
                    self.segueToMainViewController()
                }))
                if let result = UserDefaults.standard.value(forKey: "saveCredential") as? Bool, result == false {
                    self.present(actionSheet, animated: true, completion: nil)
                } else {
//                    self.performSegue(withIdentifier: "goToSecondController", sender: self)
                    self.segueToMainViewController()
                }
            } else {
                SVProgressHUD.dismiss()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.presentAlertWithTitle(title: "Atención",
                                           message: "Usuario o contraseña incorrecta",
                                           withOptions: true, options: "Ok",
                                           completion: { (_) in
                })
            }
        })
    }
    func segueToMainViewController() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = MainTabBarController()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main")
        mainViewController.modalTransitionStyle = .crossDissolve
        mainViewController.modalPresentationStyle = .fullScreen
//        UIView.animate(withDuration: 0.25) {
//            self.present(mainViewController, animated: true, completion: nil)
//        }
//        navigationController?.pushViewController(mainViewController, animated: true)
        self.show(mainViewController, sender: nil)
    }
    func saveInKeychain() {
        DispatchQueue.main.async {
            KeychainWrapper.standard.set(self.emailTextField.text!, forKey: "userEmailISK")
            KeychainWrapper.standard.set(self.passwordTextField.text!, forKey: "userPasswordISK")
            UserDefaults.standard.set(true, forKey: "saveCredential")
        }
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        //
    }
    @IBAction func contactButton(_ sender: UIButton) {
        guard let number = URL(string: Constants.URL.PhoneURL) else {return}
        if UIApplication.shared.canOpenURL(number) {
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        }
    }
}

extension LoginViewController {
    func showLoading(_ status: Bool) {
        if(status == true) {
            let initialFrame = self.view.frame
            let frame = CGRect(x: (initialFrame.width) / 2 - 20, y: (initialFrame.height) / 2 - 20, width: 40, height: 40)
            loadingView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballTrianglePath, color: UIColor.blue, padding: nil)
            self.view.addSubview(loadingView!)
            loadingView?.startAnimating()
        } else {
            loadingView?.stopAnimating()
        }
    }
}
