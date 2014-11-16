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
    var dataInsights : [DataInsight] = []
        
    func appendDataInsights(insights: [DataInsight]) {
        dataInsights = dataInsights + insights
    }
    
    func withWeightData(weightData: [(Double, Double)]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processWeightData(weightData))
        return self;
    }
    
    func withSleepData(sleepData: [(Double, Double)]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processSleepData(sleepData))
        return self;
    }

    func withDistanceData(distanceData: [(Double, Double)]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processDistanceData(distanceData))
        return self;
    }

    func withStepsData(stepData: [(Double, Double)]) -> CommunicateBuilder {
        appendDataInsights(communicateProcessor.processStepData(stepData))
        return self;
    }
    
    func build() -> String {
        let suggestions = communicateProcessor.processDataInsights(dataInsights)
        return CommunicateGenerator().generateFromData(suggestions)
    }
    
}