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
        for insight in dataInsights {
            switch insight {
            case .Weight:
                generateWeightForTrend(insight)
            case .Step:
                 generateStepForTrend(insight)
            case .Sleep:
                generateSleepForTrend(insight)
            case .Distance:
                generateDistanceForTrend(insight)
            }
        }
        return [CauseEffectSuggestion(cause: dataInsights[0], effect: dataInsights[0], suggestion: dataInsights[0])]
    }
    
    func generateWeightForTrend(trend: DataInsight) -> String {
        switch trend {
        case .Weight(.Ascending, _):
            return "chudniesz"
        case .Weight(.Descending, _):
            return "grubisz"
        case .Weight(.Steady, _):
            return "się trzymasz"
        default:
            return ""
        }
    }
    
    func generateStepForTrend(trend: DataInsight) -> String {
        switch trend {
        case .Step(.Ascending, _):
            return "dajesz!"
        case .Step(.Descending, _):
            return "oj, pokrokuj trochę"
        case .Step(.Steady, _):
            return "trzymasz tempo"
        default:
            return ""
        }
    }
    
    func generateSleepForTrend(trend: DataInsight) -> String {
        switch trend {
        case .Sleep(.Ascending, _):
            return "ty śpiochu!"
        case .Sleep(.Descending, _):
            return "weź się połóż"
        case .Sleep(.Steady, _):
            return "śpij spokojnie"
        default:
            return ""
        }
    }
    
    func generateDistanceForTrend(trend: DataInsight) -> String {
        switch trend {
        case .Distance(.Ascending, _):
            return "coraz dalej"
        case .Distance(.Descending, _):
            return "coraz bliżej"
        case .Distance(.Steady, _):
            return "metoda żabich kroków"
        default:
            return ""
        }
    }
    
}
