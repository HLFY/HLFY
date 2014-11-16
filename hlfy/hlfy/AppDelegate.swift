//
//  AppDelegate.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import UIKit
import Social
import Accounts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        println("Hello HealthKit!")
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        performUpdate([], [], [])
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.NewData)
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if let range = url.absoluteString!.rangeOfString(hlfySchemeFacebookDataURLComponent) {
            showSocialControllerForServiceType(SLServiceTypeFacebook)
            return false
        } else if let range = url.absoluteString!.rangeOfString(hlfySchemeTwitterDataURLComponent) {
            showSocialControllerForServiceType(SLServiceTypeTwitter)
            return false
        } else if let range = url.absoluteString!.rangeOfString(hlfySchemeRefreshDataURLComponent) {
            performUpdate([], [], [])
        }
        return true
    }
    
    func showSocialControllerForServiceType(serviceType: NSString!) {
        if(serviceType != SLServiceTypeTwitter && serviceType != SLServiceTypeFacebook) { return }
        
        if (SLComposeViewController.isAvailableForServiceType(serviceType)) {
            
            let mySLComposerSheet: SLComposeViewController = SLComposeViewController(forServiceType: serviceType)
            
            let hlfySharedDefaults : NSUserDefaults = NSUserDefaults(suiteName:appGroupID)!
            let communicate : String? = hlfySharedDefaults.objectForKey(widgetCommunicateKey) as? String
            mySLComposerSheet.setInitialText("\"" + communicate! + "\"\n\n#HLFY #SwiftCrunch")
            mySLComposerSheet.completionHandler = { result in
                exit(0)
            }
            self.window?.rootViewController!.presentViewController(mySLComposerSheet, animated: true, completion: nil)
        }
    }

}

