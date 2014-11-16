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
        
    @IBOutlet weak var communicateButton: UIButton!
    
    func readFromSharedContainer() {
        let hlfySharedDefaults : NSUserDefaults = NSUserDefaults(suiteName:appGroupID)!
        let communicate : String? = hlfySharedDefaults.objectForKey(widgetCommunicateKey) as? String
        if let communicate = communicate {
            let timestamp : NSDate? = hlfySharedDefaults.objectForKey(widgetCommunicateTimestampKey) as? NSDate
            if let timestamp = timestamp {
                // TODO: add logic that shows the outdated communicates
                communicateButton.setTitle(communicate, forState: .Normal)
            } else {
                requestNewData()
                communicateButton.setTitle(communicate, forState: .Normal)
            }
        } else {
            requestNewData()
            let defaultComminicate = NSLocalizedString("widgetDefaultCommunicate", comment: "")
            communicateButton.setTitle(defaultComminicate, forState: .Normal)
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
    
    @IBAction func communicateTapped() {
        if let extensionContext = self.extensionContext {
            let refreshURLScheme = hlfySchemeBaseURL + hlfySchemeRefreshDataURLComponent
            extensionContext.openURL(NSURL(string: refreshURLScheme)!, completionHandler: { urlOpened in
                if !urlOpened {
                    self.requestNewData()
                }
            })
        }
    }
    
    @IBAction func facebookTapped(sender: UIButton) {
        openAppWithSocialAction(hlfySchemeFacebookDataURLComponent)
    }
    
    @IBAction func twitterTapped(sender: UIButton) {
        openAppWithSocialAction(hlfySchemeTwitterDataURLComponent)
    }
    
    func openAppWithSocialAction(schemeURLComponent: NSString!)  {
        if(schemeURLComponent != hlfySchemeFacebookDataURLComponent
        && schemeURLComponent != hlfySchemeTwitterDataURLComponent) { return }
        
        if let extensionContext = self.extensionContext {
            let socialURLScheme = hlfySchemeBaseURL + schemeURLComponent
            extensionContext.openURL(NSURL(string: socialURLScheme)!, completionHandler: nil)
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}
