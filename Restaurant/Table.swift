//
//  Tables.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 27.03.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import Foundation
import RealmSwift

class Table: Object {
    dynamic var name = ""
    dynamic var limitPersons = 0
    let reservations = List<Reservation>()
    
    convenience init(name: String, limitPersons: Int) {
        self.init() //Please note this says 'self' and not 'super'
        self.name = name
        self.limitPersons = limitPersons
    }
    
    func title() -> String {
        return "Table №\(self.name)"
    }
    
    func isReserved() -> Bool {
        return self.reservations.count > 0
    }
    
    func reserve(reservation: Reservation) {
        reservations.append(reservation)
    }
}

class Reservation: Object {
    dynamic var name = ""
    dynamic var person = 0
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

