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
    
    enum TimeModifierPosition {
        case Beginning, Middle, End
    }
    
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
        communicate = descriptionForEffect(suggestion.effect, communicate)
        communicate = descriptionForCause(suggestion.cause, communicate)
        communicate = descriptionForSuggestion(suggestion.suggestion, communicate)
        return communicate
    }
    
    func descriptionForEffect(cause: DataInsight, _ communicate: String) -> String {
        switch cause {
        case .Distance(.Ascending, let time):
            return pastTimeModifier(time, .Beginning) + "biegasz coraz więcej. "
        case .Distance(.Descending, let time):
            return "Coraz mniej biegasz " + pastTimeModifier(time, .End)
        case .Distance(.Steady, let time):
            return "Niewiele się zmieniło " + pastTimeModifier(time, .Middle) + "jeśli chodzi o bieganie. "
        case .Weight(.Ascending, let time):
            return "Cokolwiek się przytyło " + pastTimeModifier(time, .End)
        case .Weight(.Descending, let time):
            return pastTimeModifier(time, .Beginning) + "trochę ciałka zleciało. "
        case .Weight(.Steady, let time):
            return pastTimeModifier(time, .Beginning) + "ważysz wciąż tyle samo. "
        case .Sleep(.Ascending, let time):
            return "Coraz więcej sypiasz " + pastTimeModifier(time, .End)
        case .Sleep(.Descending, let time):
            return "Czy " + pastTimeModifier(time, .Middle) + "masz problemy ze snem? "
        case .Sleep(.Steady, let time):
            return pastTimeModifier(time, .Beginning) + "śpisz stabilnie. "
        default:
            return ""
        }
    }

    func descriptionForCause(cause: DataInsight, _ communicate: String) -> String {
        switch cause {
        case .Distance(.Ascending, let time):
            return "Może dlatego, że coraz więcej biegasz " + pastTimeModifier(time, .End)
        case .Distance(.Descending, let time):
            return pastTimeModifier(time, .Beginning) + "coraz mniej biegasz - może to przyczyna?"
        case .Distance(.Steady, let time):
            return "To, że " + pastTimeModifier(time, .Middle) + "może być powodem. "
        case .Weight(.Ascending, let time):
            return "Gdyby nie to, że " + pastTimeModifier(time, .Middle) + "Twoja waga rosła, może byłoby inaczej."
        case .Weight(.Descending, let time):
            return "To pewnie dlatego, że " + pastTimeModifier(time, .Middle) + "trochę ciałka zleciało. "
        case .Weight(.Steady, let time):
            return pastTimeModifier(time, .Beginning) + "Twoja waga się nie zmienia i to może być powód. "
        case .Sleep(.Ascending, let time):
            return "Może to mieć związek z tym, że " + pastTimeModifier(time, .Middle) + "śpisz coraz więcej."
        case .Sleep(.Descending, let time):
            return "Wpływ na to może mieć coraz krótszy sen " + pastTimeModifier(time, .End)
        case .Sleep(.Steady, let time):
            return "Stabilny sen " + pastTimeModifier(time, .Middle) + "pewnie ma na to wpływ. "
        default:
            return ""
        }
    }

    func descriptionForSuggestion(cause: DataInsight, _ communicate: String) -> String {
        switch cause {
        case .Distance(.Ascending, let time):
            return "Warto, żebyś zaczął trochę więcej biegać " + futureTimeModifier(time, .End)
        case .Distance(.Descending, let time):
            return futureTimeModifier(time, .Beginning) + "spróbuj mniej biegać. "
        case .Distance(.Steady, let time):
            return "Utrzymuj " + futureTimeModifier(time, .Middle) + "to samo tempo! "
        case .Weight(.Ascending, let time):
            return futureTimeModifier(time, .Beginning) + "warto trochę przytyć. "
        case .Weight(.Descending, let time):
            return "Może warto by schudnąć " + futureTimeModifier(time, .End)
        case .Weight(.Steady, let time):
            return "Utrzymuj " + futureTimeModifier(time, .Middle) + "tą samą wagę. "
        case .Sleep(.Ascending, let time):
            return "Coraz więcej sypiasz " + futureTimeModifier(time, .End)
        case .Sleep(.Descending, let time):
            return "Czy " + futureTimeModifier(time, .Middle) + "masz problemy ze snem? "
        case .Sleep(.Steady, let time):
            return futureTimeModifier(time, .Beginning) + "śpisz stabilnie. "
        default:
            return ""
        }
    }
    
    func pastTimeModifier(timeInterval: DataInsight.TimeInterval, _ modifier: TimeModifierPosition) -> String {
        var time = ""
        switch timeInterval {
        case .Now:
            time = "ostatnio"
        case .Day:
            time = "wczoraj"
        case .HalfWeek:
            time = "w ostatnich dniach"
        case .Week:
            time = "w zeszłym tygodniu"
        case .Month:
            time = "w ostatnim miesiącu"
        }
        switch modifier {
        case .Beginning:
            time = time + " "
            var stringArray = time.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let firstArray = [stringArray.first!.capitalizedString]
            stringArray.removeAtIndex(0)
            stringArray = firstArray + stringArray
            time = stringArray.reduce("", combine: { (acc, elem) in return acc + elem })
        case .Middle:
            time = " " + time + " "
        case .End:
            time = time + ". "
        }
        return time;
    }
    
    func futureTimeModifier(timeInterval: DataInsight.TimeInterval, _ modifier: TimeModifierPosition) -> String {
        var time = ""
        switch timeInterval {
        case .Now:
            time = "wkrótce"
        case .Day:
            time = "jutro"
        case .HalfWeek:
            time = "w najbliższych dniach"
        case .Week:
            time = "w przyszłym tygodniu"
        case .Month:
            time = "w nadchodzącym miesiącu"
        }
        switch modifier {
        case .Beginning:
            time = time + " "
            var stringArray = time.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let firstArray = [stringArray.first!.capitalizedString]
            stringArray.removeAtIndex(0)
            stringArray = firstArray + stringArray
            time = stringArray.reduce("", combine: { (acc, elem) in return acc + elem })
        case .Middle:
            time = " " + time + " "
        case .End:
            time = time + ". "
        }
        return time;
    }

    
}