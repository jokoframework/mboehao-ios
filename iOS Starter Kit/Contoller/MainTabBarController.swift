//
//  MainTabBarController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 3/12/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChildrenViews()
    }
    func loadChildrenViews() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main")
        mainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.favorites, tag: 0)
        self.viewControllers = [mainViewController]
    }
}
