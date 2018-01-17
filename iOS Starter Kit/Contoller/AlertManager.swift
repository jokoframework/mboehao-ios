//
//  AlertManager.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/9/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit
import Alamofire

extension UIViewController {
    func presentAlertWithTitle(title: String, message: String,
                               withOptions: Bool,
                               options: String..., completion: @escaping (Int?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if withOptions {
            for (index, option) in options.enumerated() {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (_) in
                    completion(index)
                }))
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
