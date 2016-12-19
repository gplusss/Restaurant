//
//  PopOverViewController.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 10.12.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import UIKit
import RealmSwift
import DKChainableAnimationKit

class PopOverViewController: UIViewController {
    
    @IBOutlet weak var saveOrderButton: UIButton!
    @IBOutlet weak var orderTextView: UITextView!
    
    var reservation: Reservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveOrderButton.animation.moveX(220.0).animate(1.5)
        
        if reservation != nil {
            orderTextView.text = reservation?.notes
        }
        orderTextView.becomeFirstResponder()
        saveOrderButton.layer.cornerRadius = 10
        self.showAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveOrder(sender: UIButton) {
        //      let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        //        if orderTextView.text != nil {
        //            reservation = Reservation()
        //        vc.reservation?.notes = orderTextView.text
        
        if orderTextView.text != nil {
            let parentController = self.parent as! DetailViewController
            parentController.notesTextView.text = orderTextView.text
        }
        
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

