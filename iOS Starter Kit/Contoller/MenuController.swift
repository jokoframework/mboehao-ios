//
//  MenuController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/3/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

var ACCESO: Int = 1
var LOGOUT: Int = 1

class MenuController: UITableViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == ACCESO {
            if indexPath.row == LOGOUT {
                presentAlertWithTitle(title: "Loging out",
                                      message: "Está seguro que desea salir?",
                                      withOptions: true,
                                      options: "Si", "No",
                                      completion: { (option) in
                    if option == 0 {
                        do {
                            try Auth.auth().signOut()
                            let loginManager = FBSDKLoginManager()
                            GIDSignIn.sharedInstance().signOut()
                            loginManager.logOut()
                            UserDefaults.standard.set(false, forKey: "saveCredential")
                            self.backToRootViewController()
                        } catch {
                            print("Error signing out")
                        }
                    }
                })
            } else {
                let changePasswordStoryboard = UIStoryboard(name: "CambiarPassword", bundle: Bundle.main)
                let changePasswordVC = changePasswordStoryboard.instantiateViewController(withIdentifier: "Password")
                navigationController?.pushViewController(changePasswordVC, animated: true)
            }
        } else {
            //Se tocó la Tarea Periódica
            let preferencesStoryboard = UIStoryboard(name: "Preferences", bundle: Bundle.main)
            let preferencesVC = preferencesStoryboard.instantiateViewController(withIdentifier: "Tarea")
            navigationController?.pushViewController(preferencesVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func backToRootViewController() {
        performSegue(withIdentifier: "goToRootViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LoginViewController {
            destination.emailTextField.text = ""
            destination.passwordTextField.text = ""
        }
    }
}
