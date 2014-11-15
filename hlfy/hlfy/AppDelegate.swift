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
        let hlfySharedDefaults : NSUserDefaults = NSUserDefaults(suiteName:appGroupID)!
        let communicate = CommunicateBuilder().withWeightData([])
                                              .withStepsData([])
                                              .withDistanceData([])
                                              .withSleepData([])
                                              .build()
        hlfySharedDefaults.setObject(communicate, forKey: widgetCommunicateKey)
        hlfySharedDefaults.setObject(NSDate(), forKey: widgetCommunicateTimestampKey)
        println("data updated: " + communicate)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        println("Hello HealthKit!")
        performUpdate()
        return true
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        performUpdate()
        completionHandler(UIBackgroundFetchResult.NewData)
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        performUpdate()
        return true
    }
    
}

