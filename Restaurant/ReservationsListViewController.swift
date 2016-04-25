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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.allowsMultipleSelectionDuringEditing = true
        reservations = table.reservations.sorted("startTime", ascending: true).toArray(Reservation)
        
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let reservation = reservations[indexPath.row]
        
        performSegueWithIdentifier("editReservation", sender: reservation)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addReservation" {
            
            let controller = segue.destinationViewController as! DetailViewController
            controller.table = table
        } else if segue.identifier == "editReservation" {
            let controller = segue.destinationViewController as! DetailViewController
            controller.table = table
            controller.reservation = sender as? Reservation
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReservationTableViewCell", forIndexPath: indexPath) as! ReservationTableViewCell
        
        let reservation = reservations[indexPath.row]
        
        cell.nameLable.text = "Reserved by: \(reservation.name)"
        cell.personsLable.text = "The number of guests: \(reservation.person.description)"
        cell.startTimeLabel.text = "From: \(reservation.startTime.toString()!)"
        cell.endTimeLabel.text = "To: \(reservation.endTime.toString()!)"
        cell.phoneNumberLabel.text = "Phone +38 \(reservation.phone)"
        

    
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { action -> Void in
            let realm = try! Realm()
            realm.beginWrite()
            
            
            let reservation = self.reservations[indexPath.row]
            realm.delete(reservation)
            
            try! realm.commitWrite()

            self.reservations.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         }
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
        
    }
    

}