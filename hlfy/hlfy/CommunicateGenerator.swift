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
        (fullStop, communicate) = descriptionForCause(fullStop, suggestion.cause, communicate)
        (fullStop, communicate) = descriptionForEffect(fullStop, suggestion.effect, communicate)
        (fullStop, communicate) = descriptionForSuggestion(fullStop, suggestion.suggestion, communicate)
        return communicate
    }
    
    func descriptionForCause(fullStop: Bool, _ cause: DataInsight, _ communicate: String) -> (Bool, String) {
        return (true, "Bla.")
    }

    func descriptionForEffect(fullStop: Bool, _ cause: DataInsight, _ communicate: String) -> (Bool, String) {
        return (true, "Ble.")
    }

    func descriptionForSuggestion(fullStop: Bool, _ cause: DataInsight, _ communicate: String) -> (Bool, String) {
         return (true, "Blu.")
    }
    
}