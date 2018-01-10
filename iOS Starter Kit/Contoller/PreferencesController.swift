//
//  PreferencesController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 1/4/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit
import UserNotifications
import ActionSheetPicker_3_0

class PreferencesController: UITableViewController {

    @IBOutlet weak var taskSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timeLabel.text = UserDefaults.standard.string(forKey: "Notification Time")
        taskSwitch.setOn(UserDefaults.standard.bool(forKey: "TaskSwitch Status"), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMVC(_ sender: UIBarButtonItem) {
        //save taskSwitch status
        UserDefaults.standard.set(taskSwitch.isOn, forKey: "TaskSwitch Status")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            showTimePicker()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    func showTimePicker() {
        let timePicker = ActionSheetDatePicker(title: nil, datePickerMode: UIDatePickerMode.countDownTimer, selectedDate: nil, doneBlock: { _, value, _ in
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .positional
            
            let time = value as? Double
            let formattedString = formatter.string(from: TimeInterval(time!))
            self.timeLabel.text = formattedString
            
            UserDefaults.standard.set(formattedString, forKey: "Notification Time")
            
            self.timedNotification(inSeconds: time!, completion: { (_) in
                
            })
            
        }, cancel: { (_) in
            return
        }, origin: view)
        
        timePicker?.show()
    }
    
    
    func timedNotification(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Local Push Notification"
        content.subtitle = "Test"
        content.body = "Test of local push notification"
        
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
}
