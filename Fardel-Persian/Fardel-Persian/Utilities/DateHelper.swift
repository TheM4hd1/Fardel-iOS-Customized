//
//  DateHelper.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/16/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import Foundation

struct DateComponentUnitFormatter {
    
    private struct DateComponentUnitFormat {
        let unit: Calendar.Component
        
        let singularUnit: String
        let pluralUnit: String
        
        let futureSingular: String
        let pastSingular: String
    }
    
    private let formats: [DateComponentUnitFormat] = [
        
        DateComponentUnitFormat(unit: .year,
                                singularUnit: "YEAR",
                                pluralUnit: "YEARS",
                                futureSingular: "NEXT YEAR",
                                pastSingular: "1 YEAR AGO"),
        
        DateComponentUnitFormat(unit: .month,
                                singularUnit: "MONTH",
                                pluralUnit: "MONTHS",
                                futureSingular: "NEXT MONTH",
                                pastSingular: "1 MONTH AGO"),
        
        DateComponentUnitFormat(unit: .weekOfYear,
                                singularUnit: "WEEK",
                                pluralUnit: "WEEKS",
                                futureSingular: "NEXT WEEK",
                                pastSingular: "1 WEEK AGO"),
        
        DateComponentUnitFormat(unit: .day,
                                singularUnit: "DAY",
                                pluralUnit: "DAYS",
                                futureSingular: "TOMORROW",
                                pastSingular: "YESTERDAY"),
        
        DateComponentUnitFormat(unit: .hour,
                                singularUnit: "HOUR",
                                pluralUnit: "HOURS",
                                futureSingular: "IN AN HOUR",
                                pastSingular: "AN HOUR AGO"),
        
        DateComponentUnitFormat(unit: .minute,
                                singularUnit: "MINUTE",
                                pluralUnit: "MINUTES",
                                futureSingular: "IN A MINUTE",
                                pastSingular: "A MINUTE AGO"),
        
        DateComponentUnitFormat(unit: .second,
                                singularUnit: "SECOND",
                                pluralUnit: "SECONDS",
                                futureSingular: "JUST NOW",
                                pastSingular: "JUST NOW"),
        
        ]
    
    func string(forDateComponents dateComponents: DateComponents, useNumericDates: Bool) -> String {
        for format in self.formats {
            let unitValue: Int
            
            switch format.unit {
            case .year:
                unitValue = dateComponents.year ?? 0
            case .month:
                unitValue = dateComponents.month ?? 0
            case .weekOfYear:
                unitValue = dateComponents.weekOfYear ?? 0
            case .day:
                unitValue = dateComponents.day ?? 0
            case .hour:
                unitValue = dateComponents.hour ?? 0
            case .minute:
                unitValue = dateComponents.minute ?? 0
            case .second:
                unitValue = dateComponents.second ?? 0
            default:
                assertionFailure("Date does not have requried components")
                return ""
            }
            
            switch unitValue {
            case 2 ..< Int.max:
                return "\(unitValue) \(format.pluralUnit) AGO"
            case 1:
                return useNumericDates ? "\(unitValue) \(format.singularUnit) AGO" : format.pastSingular
            case -1:
                return useNumericDates ? "IN \(-unitValue) \(format.singularUnit)" : format.futureSingular
            case Int.min ..< -1:
                return "IN \(-unitValue) \(format.pluralUnit)"
            default:
                break
            }
        }
        
        return "JUST NOW"
    }
}



