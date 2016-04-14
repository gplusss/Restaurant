//
//  AppDelegate.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 17.03.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let realm = try! Realm()
        
        if realm.objects(Table).count == 0 {
            realm.beginWrite()
            
            realm.add(Table(name: "1", limitPersons: 10))
            realm.add(Table(name: "2", limitPersons: 5))
            realm.add(Table(name: "3", limitPersons: 2))
            realm.add(Table(name: "4", limitPersons: 1))
            realm.add(Table(name: "5", limitPersons: 2))
            realm.add(Table(name: "6", limitPersons: 7))
            realm.add(Table(name: "7", limitPersons: 6))
            realm.add(Table(name: "8", limitPersons: 4))
            
            // Commit the write transaction
            // to make this data available to other threads
            try! realm.commitWrite()
        }
        
        
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

