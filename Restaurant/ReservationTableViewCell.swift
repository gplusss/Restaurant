//
//  ReservationTableViewCell.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 05.04.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import Foundation
import UIKit

class ReservationTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLable: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var personsLable: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var person: UILabel!
    
    @IBOutlet weak var todayImageView: UIImageView!
    
}
