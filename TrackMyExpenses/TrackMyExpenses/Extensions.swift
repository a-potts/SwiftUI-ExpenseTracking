//
//  Extensions.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import Foundation
import SwiftUI

extension Color {
    
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    
    static let systemBackground = Color(UIColor.systemBackground)


    
}


//Date formatters are expensive operations so ensure it is lazy
extension DateFormatter {
    
    static let allNumericUSA: DateFormatter = {
        print("Init Date Formatter")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
    
}

extension String {
    
    func dateParse() -> Date {
        guard let parseDate = DateFormatter.allNumericUSA.date(from: self) else {
             return Date()
        }
        return parseDate
    }
    
}


extension Date: Strideable {
    func formatted()-> String {
        return self.formatted(.dateTime.year().month().day())
    }
}

extension Double {
    func roundedTo2Digits() -> Double {
        return (self * 100).rounded() / 100
    }
}
