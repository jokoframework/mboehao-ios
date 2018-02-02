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

var PREFERENCES: Int = 1
var LOGOUT: Int = 1

class MenuController: UITableViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = Auth.auth().currentUser?.email
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == PREFERENCES {
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
                            //self.dismiss(animated: true, completion: nil)
                            UserDefaults.standard.set(false, forKey: "saveCredential")
                            self.performSegue(withIdentifier: "goBackToLoginView", sender: self)
                        } catch {
                            print("Error signing out")
                        }
                    }
                })
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LoginViewController {
            destination.emailTextField.text = ""
            destination.passwordTextField.text = ""
        }
    }
}
