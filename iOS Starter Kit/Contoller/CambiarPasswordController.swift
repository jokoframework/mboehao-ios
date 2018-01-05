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
        let alert = AlarmController()
        
        
        if (currentPasswordText.text?.isEmpty)! {
            alert.genericAlert(controller: self, message: "Debe ingresar su contraseña actual")
        }else if(newPasswordText.text?.isEmpty)!{
            alert.genericAlert(controller: self, message: "Debe ingresar una nueva contraseña")
        }else if(newPasswordRepeatText.text?.isEmpty)!{
            alert.genericAlert(controller: self, message: "Debe confirmar la nueva contraseña")
        }else {
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: currentPasswordText.text!)
            
            user?.reauthenticate(with: credential, completion: { (error) in
                if error == nil {
                    if self.newPasswordText.text! == self.newPasswordRepeatText.text! {
                        user?.updatePassword(to: self.newPasswordText.text!, completion: { (error) in
                            if error == nil {
                                let alert = UIAlertController(title: "Atención", message: "Contraseña guardada con éxito", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .default, handler: { _ in
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                alert.genericAlert(controller: self, message: "Error al intentar cambiar la contraseña")
                            }
                        })
                    }else {
                        alert.genericAlert(controller: self, message: "Las contraseñas no coinciden")
                    }
                }else {
                    alert.genericAlert(controller: self, message: "Contraseña actual incorrecta")
                }
            })
        }
    }
}
