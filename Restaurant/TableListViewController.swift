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
    case today, tommorow, all
}

class TableListViewController: UITableViewController, UITextFieldDelegate {
    var tables = [Table]()
    var image = "logo.png.pagespeed.ce.k0Fb5IZC1v.png"
    var reservation = Reservation()
    let segmentController = UISegmentedControl()
    let brown = UIColor.brown.cgColor

    func segmentController(_ sender: UISegmentedControl) {
        
        let realm = try! Realm()

        var results: Results<Table>?
        if let index = SegmentIndex(rawValue: segmentController.selectedSegmentIndex) {
            switch index {
            case .today:
                results = realm.objects(Table.self).filter(NSPredicate(format: "SUBQUERY(reservations, $reservation, $reservation.startTime < %@ AND $reservation.startTime > %@).@count > 0", Date().endOfDay as CVarArg, Date().beginningOfDay() as CVarArg))
            case .tommorow:
                let tomorrow = Date() + 1.days
                results = realm.objects(Table.self).filter(NSPredicate(format: "SUBQUERY(reservations, $reservation,$reservation.startTime > %@).@count > 0 OR reservations.@count == 0", tomorrow.beginningOfDay() as CVarArg))
            case .all:
                
                results = realm.objects(Table.self)
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
        

        segmentController.frame = CGRect(x: 200, y: 30, width: 200, height: 30)
        segmentController.layer.borderColor = brown
        segmentController.layer.borderWidth  = 2
        segmentController.layer.cornerRadius = 15
        segmentController.layer.masksToBounds = true
        segmentController.insertSegment(withTitle: "RESERVED", at: 0, animated: true)
        segmentController.insertSegment(withTitle: "FREE", at: 1, animated: true)
        segmentController.insertSegment(withTitle: "ALL", at: 2, animated: true)
        segmentController.tintColor = UIColor.brown

        segmentController.addTarget(self, action: #selector(TableListViewController.segmentController(_:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(segmentController)
        segmentController.selectedSegmentIndex = 2
        self.navigationItem.titleView = segmentController
        
    
        let realm = try! Realm()
        
        for table in realm.objects(Table.self) {
            tables.append(table)
        }
        navigationController?.hidesBarsOnSwipe = true

        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let table = tables[(indexPath as NSIndexPath).row]
    
        cell.tableNameLabel.text = table.title()
        cell.tableNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        cell.sitsLabel.text = "\(table.limitPersons) SITS"
        cell.reserverdLabel.text = table.isReserved() ? "RESERVED" : "FREE"
        cell.reserverdLabel.font = UIFont.boldSystemFont(ofSize: 15)
        cell.reserverdLabel.textColor = table.isReserved() ? UIColor.red : UIColor.green
        cell.imageLable.image = UIImage(named: "logo.png.pagespeed.ce.k0Fb5IZC1v.png")
        cell.timeLabel.text = "\(table.reservations.count)"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let table = tables[(indexPath as NSIndexPath).row]

        performSegue(withIdentifier: "showDetails", sender: table)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            
            let controller = segue.destination as! ReservationsListViewController
            if let table = sender as? Table {
                controller.table = table
            }
        }
    }
}

//extension UISegmentedControl {
//    func removeBorders() {
//        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
//        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
//        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//    }
//    
//    // create a 1x1 image with this color
//    private func imageWithColor(color: UIColor) -> UIImage {
//        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        context!.setFillColor(color.cgColor);
//        context!.fill(rect);
//        let image = UIImage(named: "callIcon")//UIGraphicsGetImageFromCurrentImageContext()
//        //UIGraphicsEndImageContext()
//        return image!
//    }
//}



