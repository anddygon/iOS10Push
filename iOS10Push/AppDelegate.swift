//
//  AppDelegate.swift
//  iOS10Push
//
//  Created by xiaoP on 2017/3/8.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //注册推送
        if #available(iOS 10.0, *) {
            let entity = JPUSHRegisterEntity()
            entity.types = Int(UNAuthorizationOptions.alert.union(.sound).union(.badge).rawValue)
            let categories = unNotificationCategories()
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
            UNUserNotificationCenter.current().setNotificationCategories(categories)
        } else {
            let types = UIUserNotificationType.alert.union(.sound).union(.badge)
            let categories = userNotificationCategories()
            JPUSHService.register(forRemoteNotificationTypes: types.rawValue, categories: categories)
        }
        JPUSHService.setup(withOption: launchOptions, appKey: "7b58873131e455cdcf2511ea", channel: nil, apsForProduction: false)
        
        return true
    }
    
    @available(iOS 10.0, *)
    func unNotificationCategories() -> Set<UNNotificationCategory> {
        let action1 = UNNotificationAction(identifier: "action1", title: "策略1行为1", options: .foreground)
        let action2 = UNNotificationAction(identifier: "action2", title: "策略1行为2", options: .destructive)
        let category1 = UNNotificationCategory(identifier: "category1", actions: [action1, action2], intentIdentifiers: [], options: [])
        
        let action3 = UNNotificationAction(identifier: "action3", title: "策略2行为1", options: .foreground)
        let action4 = UNNotificationAction(identifier: "action4", title: "策略2行为2", options: .authenticationRequired)
        let category2 = UNNotificationCategory(identifier: "category2", actions: [action3, action4], intentIdentifiers: [], options: [.customDismissAction])
        
        return Set<UNNotificationCategory>(arrayLiteral: category1, category2)
    }

    func userNotificationCategories() -> Set<UIUserNotificationCategory> {
        let action1 = UIMutableUserNotificationAction()
        action1.identifier = "action1"
        action1.title = "策略1行为1"
        action1.activationMode = .foreground
        action1.isDestructive = true
        
        let action2 = UIMutableUserNotificationAction()
        action2.identifier = "action2"
        action2.title = "策略1行为2"
        action2.activationMode = .background
        action2.isAuthenticationRequired = false
        action2.isDestructive = false
        
        let category1 = UIMutableUserNotificationCategory()
        category1.identifier = "category1"
        category1.setActions([action1, action2], for: .default)
        
        let action3 = UIMutableUserNotificationAction()
        action3.identifier = "action3"
        action3.title = "策略2行为1"
        action3.activationMode = .foreground
        action3.isDestructive = true
        
        let action4 = UIMutableUserNotificationAction()
        action4.identifier = "action4"
        action4.title = "策略2行为2"
        action4.activationMode = .background
        action4.isAuthenticationRequired = false
        action4.isDestructive = false
        
        let category2 = UIMutableUserNotificationCategory()
        category2.identifier = "category2"
        category2.setActions([action1, action2], for: .default)
        
        return Set<UIUserNotificationCategory>(arrayLiteral: category1, category2)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        JPUSHService.setBadge(0)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(#function)
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(#function)
        print("注册推送失败")
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print(#function)
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        print(#function)
        completionHandler()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        print(#function)
        completionHandler()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        print(#function)
        completionHandler()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        print(#function)
        completionHandler()
    }
    
}

extension AppDelegate: JPUSHRegisterDelegate {
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print(#function)
        
        let options = UNAuthorizationOptions.alert.union(.sound).union(.badge)
        completionHandler(Int(options.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print(#function)
        JPUSHService.handleRemoteNotification(response.notification.request.content.userInfo)
        completionHandler()
    }
    
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(#function)
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.noData)
    }
    
}
