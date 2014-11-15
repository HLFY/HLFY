//
//  CommunicateBuilder.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import Foundation
import HealthKit

class CommunicateBuilder {
    
    let communicateProcessor = CommunicateProcessor()
    var dataInsights : [DataInsight]
    
    init () {
        dataInsights = []
    }
    
    func appendDataInsights(insights: [DataInsight]) {
        insights.map({ self.dataInsights.append($0) })
    }
    
    func withWeightData(weightData: [HKQuantitySample]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processWeightData(weightData))
        return self;
    }
    
    func withSleepData(sleepData: [HKCategorySample]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processSleepData(sleepData))
        return self;
    }

    func withDistanceData(distanceData: [HKQuantitySample]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processDistanceData(distanceData))
        return self;
    }

    func withStepsData(stepData: [HKQuantitySample]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processStepData(stepData))
        return self;
    }
    
    func build() -> String {
        return CommunicateGenerator().generateFromData(dataInsights)
    }
    
}