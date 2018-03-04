//
//  NotificationManager.swift
//  Knot
//
//  Created by liubo on 2018/3/4.
//  Copyright © 2018年 liubo. All rights reserved.
//

import Foundation
import UserNotifications

public class NotificationManager {
    
    static func schedule(identifier id:String, withTitle title:String,at reminder:Date){
        let calendar = Calendar.current
        let dateCompents = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: reminder)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "未完成的提醒"
        content.body = title
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "foodCategeroy"
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let err = error{
                print(err.localizedDescription)
            }
        }
    }
    
    static func scheduleDaily(){
        
        var dateCompents = DateComponents()
        dateCompents.hour = 8
        dateCompents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "新的一天"
        content.body = "要不要来做做看？"
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "_daily_notification_identifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let err = error{
                print(err.localizedDescription)
            }
        }
    }
    
    static func cancel(_ identifier:String){
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
    }
}
