//
//  CommunicateGenerator.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import Foundation

struct CommunicateGenerator {
    
    func generateFromData(data: [DataInsight]) -> String {
        var communicate = ""
        for insight in data {
            switch insight {
            case .Weight(let trend):
                communicate += generateWeightForTrend(trend) + ". "
            case .Step(let trend):
                communicate += generateStepForTrend(trend) + ". "
            case .Sleep(let trend):
                communicate += generateSleepForTrend(trend) + ". "
            case .Distance(let trend):
                communicate += generateDistanceForTrend(trend) + ". "
            }
        }
        return communicate
    }
    
    func generateWeightForTrend(trend: DataTrend) -> String {
        switch trend {
            case .Ascending:
                return "chudniesz"
            case .Descending:
                return "grubisz"
            case .Steady:
                return "się trzymasz"
        }
    }

    func generateStepForTrend(trend: DataTrend) -> String {
        switch trend {
        case .Ascending:
            return "dajesz!"
        case .Descending:
            return "oj, pokrokuj trochę"
        case .Steady:
            return "trzymasz tempo"
        }
    }

    func generateSleepForTrend(trend: DataTrend) -> String {
        switch trend {
        case .Ascending:
            return "ty śpiochu!"
        case .Descending:
            return "weź się połóż"
        case .Steady:
            return "śpij spokojnie"
        }
    }

    func generateDistanceForTrend(trend: DataTrend) -> String {
        switch trend {
        case .Ascending:
            return "coraz dalej"
        case .Descending:
            return "coraz bliżej"
        case .Steady:
            return "metoda żabich kroków"
        }
    }
    
}