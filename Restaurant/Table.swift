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

var currentDate = NSDate()

class Table: Object {
    dynamic var name = ""
    dynamic var limitPersons = Int()
    dynamic var reserved = "RESERVED"
    dynamic var free = "FREE"
    let reservations = List<Reservation>()
    
    
    convenience init(name: String, limitPersons: Int) {
        self.init() //Please note this says 'self' and not 'super'
        self.name = name
        self.limitPersons = limitPersons
        
    }
    
    func title() -> String {
        return "TABLE №\(self.name)"
    }
    //TO DO
    func isReserved() -> Bool {
//        if  reservations.count > 0 {
//          //return reservations.first?.startTime > currentDate
//        return reservations[0].startTime.isInToday()
//    }
//        return false
        if reservations.count > 0 {
        
        for time in reservations {
            if time.startTime.isInToday() && time.startTime > currentDate {
                return true
            } else {
                return false
            }
        }
        } else {
            return false
        }
        return true
        
}

    func reserve(reservation: Reservation) {
        if reservation.table == nil {
            reservation.table = self
            reservations.append(reservation)
        }
    }
}

class Reservation: Object {
    dynamic var name = ""
    dynamic var person = Int()
    dynamic var startTime = NSDate()
    dynamic var endTime = NSDate()
    dynamic var phone = ""
    dynamic var notes = ""
    dynamic var table: Table?
    
    convenience init(name: String, person: Int, startTime: NSDate, endTime: NSDate, phone: String, notes: String) {
        self.init()
        self.name = name
        self.person = person
        self.startTime = startTime
        self.endTime = endTime
        self.phone = phone
        self.notes = notes
        
    }

}

