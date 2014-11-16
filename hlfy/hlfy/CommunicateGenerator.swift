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
            let randomIndex = Int(arc4random_uniform(UInt32(data.count)))
            return descriptionForData(data[randomIndex])
        } else {
            return NSLocalizedString("widgetDefaultCommunicate", comment: "")
        }
    }
    
    func descriptionForData(suggestion: CauseEffectSuggestion) -> String {
        var communicate = ""
        var fullStop = true
        communicate += descriptionForEffect(suggestion.effect, communicate)
        communicate += descriptionForCause(suggestion.cause, communicate)
        communicate += descriptionForSuggestion(suggestion.suggestion, communicate)
        return communicate
    }
    
    func descriptionForEffect(cause: DataInsight, _ communicate: String) -> String {
        switch cause {
        case .Distance(.Ascending, let time):
            return pastTimeModifier(time, .Beginning) + "biegania było więcej. "
        case .Distance(.Descending, let time):
            return "Mniej było przebiegnięte " + pastTimeModifier(time, .End)
        case .Distance(.Steady, let time):
            return "Bez zmian " + pastTimeModifier(time, .Middle) + "w kwestii biegania. "
        case .Weight(.Ascending, let time):
            return "Przytyło Ci się " + pastTimeModifier(time, .End)
        case .Weight(.Descending, let time):
            return pastTimeModifier(time, .Beginning) + "ciałko zleciało. "
        case .Weight(.Steady, let time):
            return pastTimeModifier(time, .Beginning) + "waga była stała. "
        case .Sleep(.Ascending, let time):
            return "Snu było więcej " + pastTimeModifier(time, .End)
        case .Sleep(.Descending, let time):
            return "Czy " + pastTimeModifier(time, .Middle) + "miałeś problemy ze snem? "
        case .Sleep(.Steady, let time):
            return pastTimeModifier(time, .Beginning) + "sen był stabilny. "
        default:
            return ""
        }
    }

    func descriptionForCause(cause: DataInsight, _ communicate: String) -> String {
        switch cause {
        case .Distance(.Ascending, let time):
            return "Może dlatego, że więcej było przebiegnięte " + pastTimeModifier(time, .End)
        case .Distance(.Descending, let time):
            return pastTimeModifier(time, .Beginning) + "mniej było biegania. Czy to przyczyna? "
        case .Distance(.Steady, let time):
            return "To, że przebiegnięty dystans się nie zmienił" + pastTimeModifier(time, .Middle) + "jest powodem. "
        case .Weight(.Ascending, let time):
            return "Gdyby nie to, że " + pastTimeModifier(time, .Middle) + "Twoja waga rosła, byłoby inaczej. "
        case .Weight(.Descending, let time):
            return "To dlatego, że " + pastTimeModifier(time, .Middle) + "ciałko zleciało. "
        case .Weight(.Steady, let time):
            return pastTimeModifier(time, .Beginning) + "Twoja waga się nie zmieniła i to może być powód. "
        case .Sleep(.Ascending, let time):
            return "Ma to związek z tym, że " + pastTimeModifier(time, .Middle) + "sen był dłuższy. "
        case .Sleep(.Descending, let time):
            return "Wpływ na to ma coraz krótszy sen " + pastTimeModifier(time, .End)
        case .Sleep(.Steady, let time):
            return "Stabilny sen " + pastTimeModifier(time, .Middle) + "ma na to wpływ. "
        default:
            return ""
        }
    }

    func descriptionForSuggestion(cause: DataInsight, _ communicate: String) -> String {
        switch cause {
        case .Distance(.Ascending, let time):
            return "Warto, żebyś zaczął więcej biegać. "
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
            return "Postaraj się " + futureTimeModifier(time, .Middle) + "spać więcej. "
        case .Sleep(.Descending, let time):
            return futureTimeModifier(time, .Beginning) + "warto mniej spać. "
        case .Sleep(.Steady, let time):
            return "Śpij wciąż tyle samo " + futureTimeModifier(time, .End)
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
            var stringArray = time.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let firstArray = [stringArray.first!.capitalizedString]
            stringArray.removeAtIndex(0)
            stringArray = firstArray + stringArray
            time = stringArray.reduce("", combine: { (acc, elem) in return acc + elem + " " })
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
            var stringArray = time.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let firstArray = [stringArray.first!.capitalizedString]
            stringArray.removeAtIndex(0)
            stringArray = firstArray + stringArray
            time = stringArray.reduce("", combine: { (acc, elem) in return acc + elem + " " })
        case .Middle:
            time = " " + time + " "
        case .End:
            time = time + ". "
        }
        return time;
    }

    
}