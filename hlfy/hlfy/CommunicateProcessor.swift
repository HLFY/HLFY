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
        return [.Weight(.Ascending, .Day)]
    }

    func processSleepData(sleepData: [HKCategorySample]) -> [DataInsight] {
        return [.Sleep(.Ascending, .Day)]
    }

    func processDistanceData(distanceData: [HKQuantitySample]) -> [DataInsight] {
        return [.Distance(.Ascending, .Day)]
    }

    func processStepData(stepData: [HKQuantitySample]) -> [DataInsight] {
        return [.Step(.Ascending, .Day)]
    }
    
    func processDataInsights(dataInsights: [DataInsight]) -> [CauseEffectSuggestion] {
        var suggestions : [CauseEffectSuggestion] = []
        suggestions += suggestionsForSleepDistanceHypothesis(dataInsights)
        return suggestions
    }
    
    private func suggestionsForSleepDistanceHypothesis(dataInsights: [DataInsight]) -> [CauseEffectSuggestion] {
        return []
    }
    
}
