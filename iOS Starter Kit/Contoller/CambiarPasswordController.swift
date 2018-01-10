//
//  CambiarPasswordController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/5/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit
import Firebase

class CambiarPasswordController: UITableViewController {

    @IBOutlet weak var currentPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var newPasswordRepeatText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if (currentPasswordText.text?.isEmpty)! {
            WPSAlertController.presentOkayAlert(withTitle: "Atención", message: "Debe ingresar su contraseña actual")
        }else if(newPasswordText.text?.isEmpty)!{
            WPSAlertController.presentOkayAlert(withTitle: "Atención", message: "Debe ingresar una nueva contraseña")
        }else if(newPasswordRepeatText.text?.isEmpty)!{
            WPSAlertController.presentOkayAlert(withTitle: "Atención", message: "Debe repetir la nueva contraseña")
        }else {
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: currentPasswordText.text!)
            
            user?.reauthenticate(with: credential, completion: { (error) in
                if error == nil {
                    if self.newPasswordText.text! == self.newPasswordRepeatText.text! {
                        user?.updatePassword(to: self.newPasswordText.text!, completion: { (error) in
                            if error == nil {
                                self.presentAlertWithTitle(title: "Éxito!", message: "La nueva contraseña se guardó de forma exitosa",withOptions: true, options: "Ok", completion: { (_) in
                                    self.dismiss(animated: true, completion: nil)
                                })
                            } else {
                                WPSAlertController.presentOkayAlert(withTitle: "Error", message: "Error al intentar cambiar la contraseña")
                            }
                        })
                    }else {
                        WPSAlertController.presentOkayAlert(withTitle: "Atención", message: "Las contraseñas no coinciden")
                    }
                }else {
                    WPSAlertController.presentOkayAlert(withTitle: "Atención", message: "Contraseña actual incorrecta")
                }
            })
        }
    }
}
