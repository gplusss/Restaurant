//
//  ReservationsListViewController.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 03.04.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftDate

class ReservationsListViewController: UITableViewController {
    var table: Table!
    var reservations: [Reservation]!
    let customDateString = "dd.MM.YYYY, HH:MM"
    var stepper = DetailViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.allowsMultipleSelectionDuringEditing = true
        reservations = table.reservations.sorted(byProperty: "startTime", ascending: true).toArray(Reservation.self)
        
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reservation = reservations[(indexPath as NSIndexPath).row]
        
        performSegue(withIdentifier: "editReservation", sender: reservation)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addReservation" {
            
            let controller = segue.destination as! DetailViewController
            controller.table = table
        } else if segue.identifier == "editReservation" {
            let controller = segue.destination as! DetailViewController
            controller.table = table
            controller.reservation = sender as? Reservation
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationTableViewCell", for: indexPath) as! ReservationTableViewCell
        
        let reservation = reservations[(indexPath as NSIndexPath).row]
        
        cell.nameLable.text = "Reserved by: \(reservation.name)"
        cell.personsLable.text = "The number of guests: \(reservation.person)"
        //cell.personsLable.text = "The number of guests: \(stepper.personNumberLabel)"
        cell.startTimeLabel.text = "From: \(reservation.startTime)"
        cell.endTimeLabel.text = "To: \(reservation.endTime.string(custom: customDateString))"
        cell.phoneNumberLabel.text = "PHONE: +38\(reservation.phone)"
        cell.phoneNumberLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
        cell.nameLable.shadowColor = UIColor.blue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { action -> Void in
            let realm = try! Realm()
            realm.beginWrite()
            
            
            let reservation = self.reservations[(indexPath as NSIndexPath).row]
            realm.delete(reservation)
            
            try! realm.commitWrite()

            self.reservations.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
         }
        deleteAction.backgroundColor = UIColor.brown
        
        return [deleteAction]
        
    }
    

}
