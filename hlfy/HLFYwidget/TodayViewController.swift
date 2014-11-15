//
//  TodayViewController.swift
//  HLFYwidget
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var communicateLabel: UILabel!
    
    func performUpdate() {
        let hlfySharedDefaults : NSUserDefaults = NSUserDefaults(suiteName:appGroupID)!
        let communicate : String? = hlfySharedDefaults.objectForKey(widgetCommunicateKey) as? String
        if let communicate = communicate {
            let timestamp : NSDate? = hlfySharedDefaults.objectForKey(widgetCommunicateTimestampKey) as? NSDate
            if let timestamp = timestamp {
                // TODO: add logic that shows the outdated communicates
                
                self.communicateLabel.text = communicate
            } else {
                self.requestNewData()
                self.communicateLabel.text = communicate
            }
        } else {
            self.requestNewData()
            self.communicateLabel.text = NSLocalizedString("widgetDefaultCommunicate", comment: "")
        }
    }
    
    func requestNewData() {
        if let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier {
            NCWidgetController.widgetController().setHasContent(false, forWidgetWithBundleIdentifier: bundleIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performUpdate()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        self.performUpdate()
        completionHandler(NCUpdateResult.NewData)
    }
    
}
