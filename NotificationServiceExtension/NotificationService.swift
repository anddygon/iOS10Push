//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by xiaoP on 2017/3/8.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UserNotifications

let imageSavePath = NSHomeDirectory() + "/Documents/image.data"

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            //使用本地图片
            if let urlLocal = Bundle.main.url(forResource: "attachment", withExtension: "jpg") {
                if let attachment = try? UNNotificationAttachment(identifier: "identifier", url: urlLocal, options: nil) {
                    bestAttemptContent.attachments = [attachment]
                }
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
