//
//  DataInsight.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import Foundation
import HealthKit

enum DataInsight {
    
    enum DataTrend {
        case Ascending
        case Descending
        case Steady
    }
    
    enum TimeInterval {
        case Day
        case HalfWeek
        case Week
        case Month
    }
        
    case Weight(DataTrend, TimeInterval)
    case Sleep(DataTrend, TimeInterval)
    case Step(DataTrend, TimeInterval)
    case Distance(DataTrend, TimeInterval)
}
