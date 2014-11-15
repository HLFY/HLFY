//
//  DataInsight.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import Foundation
import HealthKit

enum DataTrend {
    case Ascending
    case Descending
    case Steady
}

enum DataInsight {
    case Weight(DataTrend)
    case Sleep(DataTrend)
    case Step(DataTrend)
    case Distance(DataTrend)
}
