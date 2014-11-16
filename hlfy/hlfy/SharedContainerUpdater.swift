//
//  SharedContainerUpdater.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 16/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import Foundation

func performUpdate(weight:[(Double, Double)],distance:[(Double, Double)]) {
    let hlfySharedDefaults : NSUserDefaults = NSUserDefaults(suiteName:appGroupID)!
    let communicate = CommunicateBuilder().withWeightData([])
        .withStepsData([])
        .withDistanceData([])
        .withSleepData([])
        .build()
    hlfySharedDefaults.setObject(communicate, forKey: widgetCommunicateKey)
    hlfySharedDefaults.setObject(NSDate(), forKey: widgetCommunicateTimestampKey)
    println("shared container data updated: " + communicate)
}


