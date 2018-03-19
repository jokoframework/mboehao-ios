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
        mainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: Constants.UI.MainItem)
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Maps",
                                                    image: UIImage(named: "map"),
                                                    tag: Constants.UI.MapItem)
        self.viewControllers = [mainViewController, mapViewController]
    }
}
