//
//  AppDelegate.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func performUpdate() {
        let hlfySharedDefaults : NSUserDefaults = NSUserDefaults(suiteName: "group.HLFY")!
        let communicate = "Hello handsome, it's \(NSDate())"
        hlfySharedDefaults.setObject(communicate, forKey: "hlfy")
        println("data updated: " + communicate)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.performUpdate()
        return true
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        self.performUpdate()
        completionHandler(UIBackgroundFetchResult.NewData)
    }

}

