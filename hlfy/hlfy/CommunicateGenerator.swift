//
//  CommunicateGenerator.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import Foundation
import Darwin

struct CommunicateGenerator {
    
    func generateFromData(data: [CauseEffectSuggestion]) -> String {
        if data.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(data.count) - UInt32(0)) + UInt32(data.count))
            return descriptionForData(data[randomIndex])
        } else {
            return NSLocalizedString("widgetDefaultCommunicate", comment: "")
        }
    }
    
    func descriptionForData(suggestion: CauseEffectSuggestion) -> String {
        var communicate = ""
        var fullStop = true
        communicate = descriptionForCause(suggestion.cause, communicate)
        communicate = descriptionForEffect(suggestion.effect, communicate)
        communicate = descriptionForSuggestion(suggestion.suggestion, communicate)
        return communicate
    }
    
    func descriptionForCause(cause: DataInsight, _ communicate: String) -> String {
        switch cause {
        case .Distance(DataInsight.DataTrend.Ascending, let time):
            return "Ble."
        default:
            return "Ble."
        }
    }

    func descriptionForEffect(cause: DataInsight, _ communicate: String) -> String {
        return "Ble."
    }

    func descriptionForSuggestion(cause: DataInsight, _ communicate: String) -> String {
         return "Blu."
    }
    
}