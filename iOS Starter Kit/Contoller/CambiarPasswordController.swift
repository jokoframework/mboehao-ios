//
//  CambiarPasswordController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/5/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class CambiarPasswordController: UITableViewController {

    @IBOutlet weak var currentPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var newPasswordRepeatText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if (currentPasswordText.text?.isEmpty)! {
            presentOkAlert(title: "Atención", message: "Debe ingresar su contraseña actual", currentView: self)
        } else if(newPasswordText.text?.isEmpty)! {
            presentOkAlert(title: "Atención", message: "Debe ingresar una nueva contraseña", currentView: self)
        } else if(newPasswordRepeatText.text?.isEmpty)! {
            presentOkAlert(title: "Atención", message: "Debe repetir la nueva contraseña", currentView: self)
        } else {
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: (user?.email)!,
                                                          password: currentPasswordText.text!)
            user?.reauthenticate(with: credential, completion: { (error) in
                if error == nil {
                    if self.newPasswordText.text! == self.newPasswordRepeatText.text! {
                        user?.updatePassword(to: self.newPasswordText.text!, completion: { (error) in
                            if error == nil {
                                self.presentAlertWithTitle(title: "Éxito!",
                                                           message: "La nueva contraseña se guardó de forma exitosa",
                                                           withOptions: true, options: "Ok",
                                                           completion: { (_) in
                                    KeychainWrapper.standard.set(self.newPasswordText.text!, forKey: "userPasswordISK")
                                    self.dismiss(animated: true, completion: nil)
                                })
                            } else {
                                self.presentOkAlert(title: "Error",
                                                    message: "Error al intentar cambiar la contraseña",
                                                    currentView: self)
                            }
                        })
                    } else {
                       self.presentOkAlert(title: "Error", message: "Las contraseñas no coinciden", currentView: self)
                    }
                } else {
                    self.presentOkAlert(title: "Error", message: "Contraseña actual incorrecta", currentView: self)
                }
            })
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
