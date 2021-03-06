//
//  Tables.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 27.03.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate

var currentDate = Date()

class Table: Object {
    dynamic var name = ""
    dynamic var limitPersons = Int()
    let reservations = List<Reservation>()
    
    convenience init(name: String, limitPersons: Int) {
        self.init() //Please note this says 'self' and not 'super'
        self.name = name
        self.limitPersons = limitPersons
        
    }
    
    func title() -> String {
        return "TABLE №\(self.name)"
    }

    func isReserved() -> Bool {
        if reservations.sorted(byProperty: "startTime", ascending: true).filter(Reservation.todayPredicate()).count > 0 {
            return true
        }
            
        return false
    }

    func reserve(_ reservation: Reservation) {
        if reservation.table == nil {
            reservation.table = self
            reservations.append(reservation)
        }
    }
}

class Reservation: Object {
    dynamic var name = ""
    dynamic var person = Int()
    dynamic var startTime = Date()
    dynamic var endTime = Date()
    dynamic var phone = ""
    dynamic var notes = ""
    dynamic var table: Table?
    
    convenience init(name: String, person: Int, startTime: Date, endTime: Date, phone: String, notes: String) {
        self.init()
        self.name = name
        self.person = person
        self.startTime = startTime
        self.endTime = endTime
        self.phone = phone
        self.notes = notes
        
    }

    static func todayPredicate() -> NSPredicate {
        return NSPredicate(format: "(startTime < %@ AND startTime > %@)", Date().endOfDay() as CVarArg, Date().beginningOfDay() as CVarArg)
    }
    
    static func tomorrowPredicate() -> NSPredicate {
        let tomorrow = Date() + 1.days
        return NSPredicate(format: "startTime > %@", tomorrow.beginningOfDay() as CVarArg)
    }
}

