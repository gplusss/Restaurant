//
//  NSDate+Extensions.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 02.05.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import Foundation

extension Date {
    
    func beginningOfDay() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
    
    func endOfDay() -> Date {
        var components = DateComponents()
        components.day = 1
        var date = (Calendar.current as NSCalendar).date(byAdding: components, to: self.beginningOfDay(), options: [])!
        date = date.addingTimeInterval(-1)
        return date
    }
}
