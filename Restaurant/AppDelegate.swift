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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let realm = try! Realm()
       
        
        if realm.objects(Table.self).count == 0 {
            realm.beginWrite()
            
            realm.add(Table(name: "1", limitPersons: 4))
            realm.add(Table(name: "2", limitPersons: 4))
            realm.add(Table(name: "3", limitPersons: 6))
            realm.add(Table(name: "4", limitPersons: 4))
            realm.add(Table(name: "5", limitPersons: 8))
            realm.add(Table(name: "6", limitPersons: 8))
            realm.add(Table(name: "7", limitPersons: 3))
            realm.add(Table(name: "8", limitPersons: 8))
            realm.add(Table(name: "9", limitPersons: 6))
            realm.add(Table(name: "10", limitPersons: 30))
            realm.add(Table(name: "11", limitPersons: 30))
            realm.add(Table(name: "12", limitPersons: 10))
            
            // Commit the write transaction
            // to make this data available to other threads
            try! realm.commitWrite()
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

