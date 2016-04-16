//
//  Realm+Extensions.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 15.04.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for result in self {
            if let result = result as? T {
                array.append(result)
            }
        }
        return array
    }
    
}