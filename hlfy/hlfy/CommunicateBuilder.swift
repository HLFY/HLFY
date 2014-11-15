//
//  CommunicateBuilder.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import Foundation
import HealthKit

struct CommunicateBuilder {
    
    let communicateProcessor = CommunicateProcessor()
    var dataInsights : [DataInsight]
    
    init () {
        dataInsights = []
    }
    
    mutating func appendDataInsights(insights: [DataInsight]) {
        insights.map({ self.dataInsights.append($0) })
    }
    
    mutating func withWeightData(weightData: [HKQuantitySample]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processWeightData(weightData))
        return self;
    }
    
    mutating func withSleepData(sleepData: [HKCategorySample]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processSleepData(sleepData))
        return self;
    }

    mutating func withDistanceData(distanceData: [HKCategorySample]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processDistanceData(distanceData))
        return self;
    }

    mutating func withStepsData(stepData: [HKCategorySample]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processStepData(stepData))
        return self;
    }
    
    func build() -> String {
        return CommunicateGenerator().generateFromData(dataInsights)
    }
    
}