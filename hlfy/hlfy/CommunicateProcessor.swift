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
    
    func processWeightData(weightData: [(Double, Double)]) -> [DataInsight] {
        var insights : [DataInsight] = []
        if let relative = weightData.last {
            for weight in weightData {
                let interval = intervalForDates(weight.0, relative.0)
                let trend = trendForValues(weight.1, weight.1)
                insights.append(.Weight(trend, interval))
            }
        }
        return insights
    }

    func processSleepData(sleepData: [(Double, Double)]) -> [DataInsight] {
        var insights : [DataInsight] = []
        if let relative = sleepData.last {
            for weight in sleepData {
                let interval = intervalForDates(weight.0, relative.0)
                let trend = trendForValues(weight.1, weight.1)
                insights.append(.Sleep(trend, interval))
            }
        }
        return insights
    }

    func processDistanceData(distanceData: [(Double, Double)]) -> [DataInsight] {
        var insights : [DataInsight] = []
        if let relative = distanceData.last {
            for weight in distanceData {
                let interval = intervalForDates(weight.0, relative.0)
                let trend = trendForValues(weight.1, weight.1)
                insights.append(.Distance(trend, interval))
            }
        }
        return insights
    }

    func processStepData(stepData: [(Double, Double)]) -> [DataInsight] {
        var insights : [DataInsight] = []
        if let relative = stepData.last {
            for weight in stepData {
                let interval = intervalForDates(weight.0, relative.0)
                let trend = trendForValues(weight.1, weight.1)
                insights.append(.Step(trend, interval))
            }
        }
        return insights
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
    
    func intervalForDates(start: Double, _ end: Double) -> DataInsight.TimeInterval {
        let delta = end - start
        switch delta {
        case let x where x >= 0.0 && x < dailyInterval:
            return .Now
        case let x where x >= dailyInterval && x < dailyInterval*2:
            return .Day
        case let x where x >= dailyInterval*2 && x < dailyInterval*5:
            return .HalfWeek
        case let x where x >= dailyInterval*5 && x < dailyInterval*10:
            return .Week
        default:
            return .Month
        }
    }
    
    func trendForValues(start: Double, _ end: Double) -> DataInsight.DataTrend {
        switch (start, end) {
        case let (x,y) where x < y:
            return .Ascending
        case let (x, y) where x > y:
            return .Descending
        default:
            return .Steady
        }
    }
    
}
