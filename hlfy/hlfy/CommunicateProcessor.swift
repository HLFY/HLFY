//
//  CommunicateProcessor.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import Foundation
import HealthKit

struct CommunicateProcessor {
    
    func processWeightData(weightData: [HKQuantitySample]) -> [DataInsight] {
        return [.Weight(.Ascending)]
    }

    func processSleepData(sleepData: [HKCategorySample]) -> [DataInsight] {
        return [.Sleep(.Ascending)]
    }

    func processDistanceData(distanceData: [HKCategorySample]) -> [DataInsight] {
        return [.Distance(.Ascending)]
    }

    func processStepData(stepData: [HKCategorySample]) -> [DataInsight] {
        return [.Step(.Ascending)]
    }    
    
}
