//
//  AppDelegate.swift
//  guangdiu
//
//  Created by Nick on 15/3/11.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import UIKit
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    //TODO: 数据库结构变动时，app启动会报错。需要进行migration操作。但下面注释掉的代码执行时会报“Cannot set schema version for Realms that are already open.”的错误。如何解决？
//    RLMRealm.setSchemaVersion(1, forRealmAtPath: RLMRealm.defaultRealmPath()) { (migration, oldSchemaVersion) -> Void in
//      migration.enumerateObjects(Item.className(), block: { (oldObj, newObj) -> Void in
//        if oldSchemaVersion < 1 {
//          newObj["site"] = ""
//        }
//      })
//      migration.enumerateObjects(FavItem.className(), block: { (oldObj, newObj) -> Void in
//        if oldSchemaVersion < 1 {
//          newObj["site"] = ""
//        }
//      })
//    }
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

