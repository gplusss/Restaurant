//
//  PopOverViewController.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 10.12.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import UIKit
import RealmSwift

class PopOverViewController: UIViewController {
    
    var reservation: Reservation?
    var note: DetailViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.showAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var orderTextView: UITextView!
    @IBAction func saveOrder(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        if orderTextView.text != nil {
            reservation = Reservation()
        vc.reservation!.notes = orderTextView.text
            
        }
//        let realm = try! Realm()
//        realm.beginWrite()
//        if orderTextView == nil {
//            note.reservation?.notes = orderTextView.text
//
//            realm.add(reservation!)
//        }
//        
//        
//        try! realm.commitWrite()
        self.removeAnimate()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
        
    }

    
}

protocol PopOverViewControllerDelegate {
    func passData(noteField: String)
    
}
