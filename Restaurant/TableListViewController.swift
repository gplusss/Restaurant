//
//  TableListViewController.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 17.03.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate

enum SegmentIndex: Int {
    case Today, Tommorow, All
}

class TableListViewController: UITableViewController, UITextFieldDelegate {
    var tables = [Table]()
    var image = "logo.png.pagespeed.ce.k0Fb5IZC1v.png"
    var reservation = Reservation()

    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    @IBAction func segmentController(sender: UIBarButtonItem) {
        let realm = try! Realm()

        var results: Results<Table>?
        if let index = SegmentIndex(rawValue: segmentController.selectedSegmentIndex) {
            switch index {
            case .Today:
                results = realm.objects(Table).filter(NSPredicate(format: "SUBQUERY(reservations, $reservation, $reservation.startTime < %@ AND $reservation.startTime > %@).@count > 0", NSDate().endOfDay(), NSDate().beginningOfDay()))
            case .Tommorow:
                let tomorrow = NSDate() + 1.days
                results = realm.objects(Table).filter(NSPredicate(format: "SUBQUERY(reservations, $reservation,$reservation.startTime > %@).@count > 0", tomorrow.beginningOfDay()))
            case .All:
                results = realm.objects(Table)
            }
        }
        
        if let results = results {
            tables.removeAll()
            
            for table in results {
                tables.append(table)
            }
        }

        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        for table in realm.objects(Table) {
            tables.append(table)
        }
        navigationController?.hidesBarsOnSwipe = true
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        
        let table = tables[indexPath.row]
    
        cell.tableNameLabel.text = table.title()
        cell.tableNameLabel.font = UIFont.boldSystemFontOfSize(25)
        cell.sitsLabel.text = "\(table.limitPersons) SITS"
        cell.reserverdLabel.text = table.isReserved() ? "RESERVED" : "FREE"
        cell.reserverdLabel.font = UIFont.boldSystemFontOfSize(15)
        cell.reserverdLabel.textColor = table.isReserved() ? UIColor.redColor() : UIColor.greenColor()
        cell.imageLable.image = UIImage(named: "logo.png.pagespeed.ce.k0Fb5IZC1v.png")
        cell.timeLabel.text = "\(table.reservations.count)"
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let table = tables[indexPath.row]

        performSegueWithIdentifier("showDetails", sender: table)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            
            let controller = segue.destinationViewController as! ReservationsListViewController
            if let table = sender as? Table {
                controller.table = table
            }
        }
    }
}





