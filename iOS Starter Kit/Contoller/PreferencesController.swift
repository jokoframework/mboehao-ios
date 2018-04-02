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
    public var preferences = NotificationPreferences()
    //Folder donde se guarda las preferencias del usuario
    let dataFilepath = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask).first?.appendingPathComponent("preferences.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPreferences()
        //Actualizar etiquetas a los valores guardados como default
        taskSwitch.addTarget(self, action: #selector(savePreferences), for: UIControlEvents.valueChanged)
        updateLabels()
    }
    func loadPreferences() {
        if let data = try? Data(contentsOf: dataFilepath!) {
            let decorder = PropertyListDecoder()
            do {
                preferences = try decorder.decode(NotificationPreferences.self, from: data)
            } catch {
                print("Error decodificando, \(error)")
            }
        }
    }
    func updateLabels() {
        timeLabel.text = preferences.timeLabel
        taskSwitch.setOn(preferences.taskSwitch, animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            showTimePicker()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func showTimePicker() {
        let timePicker = ActionSheetDatePicker(title: nil,
                                               datePickerMode: UIDatePickerMode.time,
                                               selectedDate: Calendar.current.date(from: preferences.time),
                                               doneBlock: { (_, value, _) in
                                                let selectedDate = (value as? Date)!
                                                //swiftlint:disable line_length
                                                self.preferences.time = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
                                                self.preferences.timeLabel = self.formatDate(date: self.preferences.time)
                                                //Actualizar la etiqueta
                                                self.timeLabel.text = UserDefaults.standard.string(forKey: "Notification Time")
                                                //swiftlint:enable line_length
                                                self.updateLabels()
        }, cancel: { (_) in
            return
        }, origin: view)
        timePicker?.show()
    }
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(preferences)
            try data.write(to: self.dataFilepath!)
        } catch {
            print("Error encoding data, \(error)")
        }
    }
    func formatDate(date: DateComponents) -> String {
        let formattedDate: String
        let minutes = date.minute! > 9 ? "\(date.minute!)" : "0" + "\(date.minute!)"
        formattedDate = "\(date.hour!)" + ":" + minutes
        return formattedDate
    }
    func timedNotification(time: DateComponents, completion: @escaping (_ Success: Bool) -> Void) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
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
    @objc func savePreferences() {
        if self.taskSwitch.isOn {
            self.preferences.taskSwitch = true
            self.timedNotification(time: self.preferences.time, completion: { (_) in
                print("La alarma se configuró correctamente")
            })
        } else {
            self.preferences.taskSwitch = false
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["customNotification"])
        }
        self.saveData()
    }
}
