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

class ReservationsListViewController: UITableViewController {
    var table: Table!
    var reservations: [Reservation]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        reservations = table.reservations.sorted("startTime", ascending: false).toArray(Reservation)
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        cell.nameLable.text = "Reserved by: \(reservation.name)"
        cell.personsLable.text = "The number of guests: \(reservation.person.description)"
        cell.startTimeLabel.text = "From: \(dateFormatter.stringFromDate(reservation.startTime))"
        cell.endTimeLabel.text = "To: \(dateFormatter.stringFromDate(reservation.endTime))"
        cell.phoneNumberLabel.text = "Phone +38 \(reservation.phone)"
       
        return cell
    }
    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableView, forRowAtIndexPath indexPath: UITableView) {
//
//    }
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