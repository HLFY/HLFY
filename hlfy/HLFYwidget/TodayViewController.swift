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
    
    func readFromSharedContainer() {
        let hlfySharedDefaults : NSUserDefaults = NSUserDefaults(suiteName:appGroupID)!
        let communicate : String? = hlfySharedDefaults.objectForKey(widgetCommunicateKey) as? String
        if let communicate = communicate {
            let timestamp : NSDate? = hlfySharedDefaults.objectForKey(widgetCommunicateTimestampKey) as? NSDate
            if let timestamp = timestamp {
                // TODO: add logic that shows the outdated communicates
                
                communicateLabel.text = communicate
            } else {
                requestNewData()
                communicateLabel.text = communicate
            }
        } else {
            requestNewData()
            communicateLabel.text = NSLocalizedString("widgetDefaultCommunicate", comment: "")
        }
    }
    
    func requestNewData() {
        if let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier {
            NCWidgetController.widgetController().setHasContent(false, forWidgetWithBundleIdentifier: bundleIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromSharedContainer()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        readFromSharedContainer()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        readFromSharedContainer()
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}
