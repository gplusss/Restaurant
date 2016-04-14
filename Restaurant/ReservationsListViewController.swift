//
//  ReservationsListViewController.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 03.04.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import Foundation
import UIKit

class ReservationsListViewController: UITableViewController {
    var table: Table!
        var cellArray : [Reservation] = []
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        table.reservations.sortInPlace ({ $0.startTime.compare($1.endTime) == NSComparisonResult.OrderedAscending })

        tableView.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addReservation" {
            
            let controller = segue.destinationViewController as! DetailViewController
            controller.table = table
        }
    }
        
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.reservations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReservationTableViewCell", forIndexPath: indexPath) as! ReservationTableViewCell
        
        let reservation = table.reservations[indexPath.row]
        
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { action -> Void in
            self.table.reservations.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        //let item = self.table.reservations[indexPath.row]
        //let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        //self.presentViewController(activityViewController, animated: true, completion: nil)
    }
        deleteAction.backgroundColor = UIColor.blueColor()
        return [deleteAction]
    }
    

}