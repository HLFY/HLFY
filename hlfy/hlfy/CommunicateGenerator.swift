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
        let randomIndex = Int(arc4random_uniform(UInt32(data.count) - UInt32(0)) + UInt32(data.count))
        return descriptionForSuggestion(data[randomIndex])
    }
    
    func descriptionForSuggestion(suggestion: CauseEffectSuggestion) -> String {
        return "cokolwiek"
    }
    
}