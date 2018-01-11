//
//  SecondViewController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/14/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import UIKit
import Firebase
import WebKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data: [String] = ["1", "2", "3"]
    
    @IBOutlet weak var openSideMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        openSideMenu.target = self.revealViewController()
        openSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        revealViewController().rearViewRevealWidth = 300
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.populate), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)
        
//        DispatchQueue.main.async {
//            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounterLabel), userInfo: nil, repeats: true)
//        }
        
    }
    
//    @objc func updateCounterLabel(){
//        print("I'm here")
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let text = data[indexPath.row]
        
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    @objc func populate(){
        for i in 4...15 {
            data.append("\(i)")
        }
        
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue){}

}
