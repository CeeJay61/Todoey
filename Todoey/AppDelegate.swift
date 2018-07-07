//
//  AppDelegate.swift
//  Todoey
//
//  Created by christopher hines on 2018-05-15.
//  Copyright © 2018 christopher hines. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // create a new Realm persistant container
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm, \(error)")
        } // *** do ... catch ***

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // This process happens when something interupts the user - i.e. a phone call.  The app goes to the background.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // This process will put the app into the background but not terminate it.
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      
    }

} // *** AppDelegate ***
