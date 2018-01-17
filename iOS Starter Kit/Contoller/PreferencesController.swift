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
    var preferences = NotificationPreferences()
    //Foler donde se guarda las preferencias del usuario
    let dataFilepath = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask).first?.appendingPathComponent("preferences.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPreferences()
        //Actualizar etiquetas a los valores guardados como default
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func unwindToMVC(_ sender: UIBarButtonItem) {
        //save taskSwitch status
        self.dismiss(animated: true, completion: nil)
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
    @IBAction func savedPreferences(_ sender: UIBarButtonItem) {
        preferences.taskSwitch = taskSwitch.isOn
        if taskSwitch.isOn {
            self.timedNotification(time: preferences.time, completion: { (_) in
                //swiftlint:disable:next line_length
                let alert = UIAlertController(title: "Éxito!", message: "La alarma fue programada con éxito para las \(self.preferences.timeLabel)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            print("Se borraron las alarmas")
            //swiftlint:disable:next line_length
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["customNotification"])
        }
        saveData()
    }
}
