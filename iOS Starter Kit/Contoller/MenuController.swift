//
//  MenuController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/3/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit
import Firebase

class MenuController: UITableViewController {

    
    @IBOutlet weak var navigationBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = Auth.auth().currentUser?.email
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                presentAlertWithTitle(title: "Loging out", message: "Está seguro que desea salir?", withOptions: true, options: "Si", "No", completion: { (option) in
                    if option == 0 {
                        do{
                            try Auth.auth().signOut()
                            self.dismiss(animated: true, completion: nil)
                        } catch{
                            print("Error signing out")
                        }
                    }
                })
            }
        }
    }
}
