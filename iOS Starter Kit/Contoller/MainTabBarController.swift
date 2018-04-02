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
        let mapsStoryboard = UIStoryboard(name: "Maps", bundle: Bundle.main)
        let mapViewController = mapsStoryboard.instantiateViewController(withIdentifier: "Map")
        mapViewController.tabBarItem = UITabBarItem(title: "Maps",
                                                    image: UIImage(named: "map"),
                                                    tag: Constants.UI.MapItem)
        let settingsStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let settingsViewController = settingsStoryboard.instantiateViewController(withIdentifier: "Preferences")
        settingsViewController.tabBarItem = UITabBarItem(title: "Configuración", image: UIImage(named: "settings"), tag: 2)
        self.viewControllers = [mainViewController, mapViewController, settingsViewController]
    }
}
