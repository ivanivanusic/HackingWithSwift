//
//  ViewController.swift
//  Project21
//
//  Created by Ivan Ivanušić on 23/09/2020.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    var timeForNotification = 5.00

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wakeup call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeForNotification, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let reminder = UNNotificationAction(identifier: "reminder", title: "Remind me later", options: [])
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data recieved \(customData)")
            var ac: UIAlertController
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // The user swiped to unlock
                print("Default identifier")
                ac = UIAlertController(title: "Default handler", message: nil, preferredStyle: .alert)
                
            case "show":
                print("Show more information.")
                ac = UIAlertController(title: "Show handler", message: nil, preferredStyle: .alert)
                
            case "reminder":
                print("Reminder for tomorrow")
                timeForNotification = 86400.00
                scheduleLocal()
                ac = UIAlertController(title: "Reminder handler", message: nil, preferredStyle: .alert)
                
            default:
                ac = UIAlertController(title: "Other handler", message: nil, preferredStyle: .alert)
                break
            }
            ac.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
        completionHandler()
    }
}

