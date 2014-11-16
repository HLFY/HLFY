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
        suggestions += suggestionsForSleepDistanceHypothesis(dataInsights)
        suggestions += suggestionsForDistanceWeightHypothesis(dataInsights)
        suggestions += suggestionsForSleepWeightHypothesis(dataInsights)
        suggestions += suggestionsForDistanceSleepHypothesis(dataInsights)
        suggestions += suggestionsForWeightSleepHypothesis(dataInsights)
        return suggestions
    }
    
    // więcej śpisz, więcej biegasz (s - d)
    private func suggestionsForSleepDistanceHypothesis(dataInsights: [DataInsight]) -> [CauseEffectSuggestion] {
        let sleep = sleepData(dataInsights)
        let distance = distanceData(dataInsights)
        
        if (halfFilteredData(sleep, trend: .Ascending).count > 0
            && halfFilteredData(distance, trend: .Ascending).count > 0) {
                let cause = halfFilteredData(sleep, trend: .Ascending).first
                let effect = halfFilteredData(distance, trend: .Ascending).last
                let suggestion = DataInsight.Sleep(.Steady, .HalfWeek)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        } else if (halfFilteredData(sleep, trend: .Descending).count > 0
            && halfFilteredData(distance, trend: .Descending).count > 0) {
                let cause = halfFilteredData(sleep, trend: .Descending).first
                let effect = halfFilteredData(distance, trend: .Descending).last
                let suggestion = DataInsight.Sleep(.Ascending, .Week)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        }
        return []
    }
    
    // więcej biegasz, chudniesz (d - w)
    private func suggestionsForDistanceWeightHypothesis(dataInsights: [DataInsight]) -> [CauseEffectSuggestion] {
        let weight = weightData(dataInsights)
        let distance = distanceData(dataInsights)
        
        if (halfFilteredData(weight, trend: .Descending).count > 0
            && halfFilteredData(distance, trend: .Ascending).count > 0) {
                let cause = halfFilteredData(distance, trend: .Ascending).first
                let effect = halfFilteredData(weight, trend: .Ascending).last
                let suggestion = DataInsight.Distance(.Steady, .Now)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        } else if (halfFilteredData(weight, trend: .Ascending).count > 0
            && halfFilteredData(distance, trend: .Descending).count > 0) {
                let cause = halfFilteredData(distance, trend: .Descending).first
                let effect = halfFilteredData(weight, trend: .Descending).last
                let suggestion = DataInsight.Distance(.Ascending, .Week)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        }
        
        return []
    }
    
    // mniej śpisz, chudniesz (s - w)
    private func suggestionsForSleepWeightHypothesis(dataInsights: [DataInsight]) -> [CauseEffectSuggestion] {
        let sleep = sleepData(dataInsights)
        let weight = weightData(dataInsights)
        
        if (halfFilteredData(weight, trend: .Descending).count > 0
            && halfFilteredData(sleep, trend: .Descending).count > 0) {
                let cause = halfFilteredData(sleep, trend: .Descending).first
                let effect = halfFilteredData(weight, trend: .Descending).last
                let suggestion = DataInsight.Sleep(.Steady, .Now)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        } else if (halfFilteredData(weight, trend: .Ascending).count > 0
            && halfFilteredData(sleep, trend: .Ascending).count > 0) {
                let cause = halfFilteredData(sleep, trend: .Ascending).first
                let effect = halfFilteredData(weight, trend: .Ascending).last
                let suggestion = DataInsight.Distance(.Ascending, .Week)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        }
        
        return []
        
    }
    
    // więcej biegasz, więcej śpisz (d - s)
    private func suggestionsForDistanceSleepHypothesis(dataInsights: [DataInsight]) -> [CauseEffectSuggestion] {
        let sleep = sleepData(dataInsights)
        let distance = distanceData(dataInsights)
        
        if (halfFilteredData(distance, trend: .Descending).count > 0
            && halfFilteredData(sleep, trend: .Descending).count > 0) {
                let cause = halfFilteredData(distance, trend: .Descending).first
                let effect = halfFilteredData(sleep, trend: .Descending).last
                let suggestion = DataInsight.Distance(.Ascending, .Now)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        } else if (halfFilteredData(distance, trend: .Ascending).count > 0
            && halfFilteredData(sleep, trend: .Ascending).count > 0) {
                let cause = halfFilteredData(distance, trend: .Ascending).first
                let effect = halfFilteredData(sleep, trend: .Ascending).last
                let suggestion = DataInsight.Distance(.Steady, .Week)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        }
        
        return []
    }
    
    // chudniesz, mniej śpisz (w - s)
    private func suggestionsForWeightSleepHypothesis(dataInsights: [DataInsight]) -> [CauseEffectSuggestion] {
        let sleep = sleepData(dataInsights)
        let weight = weightData(dataInsights)
        
        if (halfFilteredData(weight, trend: .Descending).count > 0
            && halfFilteredData(sleep, trend: .Descending).count > 0) {
                let cause = halfFilteredData(weight, trend: .Descending).first
                let effect = halfFilteredData(sleep, trend: .Descending).last
                let suggestion = DataInsight.Weight(.Ascending, .Now)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        } else if (halfFilteredData(weight, trend: .Ascending).count > 0
            && halfFilteredData(sleep, trend: .Ascending).count > 0) {
                let cause = halfFilteredData(weight, trend: .Ascending).first
                let effect = halfFilteredData(sleep, trend: .Ascending).last
                let suggestion = DataInsight.Weight(.Steady, .Week)
                return [CauseEffectSuggestion(cause: cause!, effect: effect!, suggestion: suggestion)]
        }
        
        return []
    }
    
    func intervalForDates(start: Double, _ end: Double) -> DataInsight.TimeInterval {
        let delta = end - start
        switch delta {
        case let x where x >= 0.0 && x < dayInterval:
            return .Now
        case let x where x >= dayInterval && x < dayInterval*2:
            return .Day
        case let x where x >= dayInterval*2 && x < dayInterval*5:
            return .HalfWeek
        case let x where x >= dayInterval*5 && x < dayInterval*10:
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
    
    func sleepData(data: [DataInsight]) -> [DataInsight] {
        return data.filter({ insight in
            switch insight {
            case .Sleep(_,_):
                return true
            default:
                return false
            }
        })
    }
    
    func weightData(data: [DataInsight]) -> [DataInsight] {
        return data.filter({ insight in
            switch insight {
            case .Weight(_,_):
                return true
            default:
                return false
            }
        })
    }
    
    func stepsData(data: [DataInsight]) -> [DataInsight] {
        return data.filter({ insight in
            switch insight {
            case .Step(_,_):
                return true
            default:
                return false
            }
        })
    }
    
    func distanceData(data: [DataInsight]) -> [DataInsight] {
        return data.filter({ insight in
            switch insight {
            case .Distance(_,_):
                return true
            default:
                return false
            }
        })
    }
    
    func filteredData(data: [DataInsight], trend: DataInsight.DataTrend, interval: DataInsight.TimeInterval) -> [DataInsight] {
        return data.filter({ insight in
            switch insight {
            case .Weight(trend,interval):
                return true
            case .Sleep(trend,interval):
                return true
            case .Step(trend,interval):
                return true
            case .Distance(trend,interval):
                return true
            default:
                return false
            }
        })
    }
    
    func halfFilteredData(data: [DataInsight], trend: DataInsight.DataTrend) -> [DataInsight] {
        return data.filter({ insight in
            switch insight {
            case .Weight(trend,_):
                return true
            case .Sleep(trend,_):
                return true
            case .Step(trend,_):
                return true
            case .Distance(trend,_):
                return true
            default:
                return false
            }
        })
    }

}
