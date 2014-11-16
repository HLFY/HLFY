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
        suggestions += [suggestionsForSleepDistanceHypothesis(dataInsights)]
        suggestions += [suggestionsForDistanceWeightHypothesis(dataInsights)]
        suggestions += [suggestionsForSleepWeightHypothesis(dataInsights)]
        suggestions += [suggestionsForDistanceSleepHypothesis(dataInsights)]
        suggestions += [suggestionsForWeightSleepHypothesis(dataInsights)]
        return suggestions
    }
    
    // więcej śpisz, więcej biegasz (s - d)
    private func suggestionsForSleepDistanceHypothesis(dataInsights: [DataInsight]) -> CauseEffectSuggestion {
        let cause = DataInsight.Sleep(.Ascending, .Month)
        let effect = DataInsight.Distance(.Ascending, .Week)
        let suggestion = DataInsight.Sleep(.Steady, .HalfWeek)
        return CauseEffectSuggestion(cause: cause, effect: effect, suggestion: suggestion)
    }
    
    // więcej biegasz, chudniesz (d - w)
    private func suggestionsForDistanceWeightHypothesis(dataInsights: [DataInsight]) -> CauseEffectSuggestion {
        let cause = DataInsight.Distance(.Descending, .Week)
        let effect = DataInsight.Weight(.Ascending, .Month)
        let suggestion = DataInsight.Distance(.Ascending, .HalfWeek)
        return CauseEffectSuggestion(cause: cause, effect: effect, suggestion: suggestion)
    }
    
    // mniej śpisz, chudniesz (s - w)
    private func suggestionsForSleepWeightHypothesis(dataInsights: [DataInsight]) -> CauseEffectSuggestion {
        let cause = DataInsight.Sleep(.Descending, .HalfWeek)
        let effect = DataInsight.Weight(.Descending, .Week)
        let suggestion = DataInsight.Distance(.Ascending, .Now)
        return CauseEffectSuggestion(cause: cause, effect: effect, suggestion: suggestion)
    }
    
    // więcej biegasz, więcej śpisz (d - s)
    private func suggestionsForDistanceSleepHypothesis(dataInsights: [DataInsight]) -> CauseEffectSuggestion {
        let cause = DataInsight.Distance(.Ascending, .Week)
        let effect = DataInsight.Sleep(.Ascending, .HalfWeek)
        let suggestion = DataInsight.Distance(.Steady, .Month)
        return CauseEffectSuggestion(cause: cause, effect: effect, suggestion: suggestion)
    }
    
    // chudniesz, mniej śpisz (w - s)
    private func suggestionsForWeightSleepHypothesis(dataInsights: [DataInsight]) -> CauseEffectSuggestion {
        let cause = DataInsight.Weight(.Descending, .Month)
        let effect = DataInsight.Sleep(.Descending, .Week)
        let suggestion = DataInsight.Weight(.Ascending, .Now)
        return CauseEffectSuggestion(cause: cause, effect: effect, suggestion: suggestion)
    }
    
}
