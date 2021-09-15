//
//  NotificationManager.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 15.09.21.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    let center = UNUserNotificationCenter.current()
    func requestNotificationAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("grantd, error", granted, error)
        }
    }

    func createPushNotificationWithTime(flowerName: String, dateInterval: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Water \(flowerName)!"
        content.body = "\(dateInterval) days have been passed since  \(flowerName)'s last watering"
        
        let date =  Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * dateInterval))
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            //Check the error parameter for unhandled errors
        }
    }
    
    
}
