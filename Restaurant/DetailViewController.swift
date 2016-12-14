//
//  DetailViewController.swift
//  Restaurant
//
//  Created by Vladimir Saprykin on 28.03.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class DetailViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var startDateTextLabel: UITextField!
    @IBOutlet weak var endDateTextLable: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var personNumberLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var showPopButton: UIButton!
    @IBAction func stepperAction(_ sender: UIStepper) {
        personNumberLabel.text = "\(Int(stepper.value))"
    }
    
    @IBAction func makeCall(sender: UIButton) {
        callNumber(phoneNumber: (phoneTextField?.text!)!)
    }
    
    var currentTextField: UITextField!
    var startDate: Date?
    var endDate: Date?
    var table: Table!
    var reservation: Reservation?
    let customDateString = "YYYY.MM.dd, HH:mm"
    
    lazy var accessoryToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolbar.barStyle = UIBarStyle.default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.cancelDidPressed)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.doneDidPressed))]
        toolbar.sizeToFit()
        return toolbar
    }()
    
    func callNumber(phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print(success) } )
            } else {
                let success = UIApplication.shared.openURL(url)
                print(success)
            }
        }
    }
    func cancelDidPressed() {
        view.endEditing(true)
    }
    //TODO: сделать правильно
    func doneDidPressed() {
        if let tf = currentTextField {
            _ = textFieldShouldReturn(tf)
        }
    }
   
    lazy var textFields: [UITextField] = {
        return [self.nameTextField, self.phoneTextField, self.startDateTextLabel, self.endDateTextLable]
    }()
    
    @IBAction func startDateTextLabel(_ sender: UITextField) {
        let startDatePickerView: UIDatePicker = UIDatePicker()
        startDatePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        startDatePickerView.minuteInterval = 1
        sender.inputView = startDatePickerView
        
        startDatePickerView.addTarget(self, action: #selector(DetailViewController.startDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @IBAction func endDateTextLable(_ sender: UITextField) {
        let endDatePickerView: UIDatePicker = UIDatePicker()
        endDatePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        endDatePickerView.minuteInterval = 15
        sender.inputView = endDatePickerView
        
        endDatePickerView.addTarget(self, action: #selector(DetailViewController.endDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var frameRect = notesTextView.frame
        frameRect.size.height = 100
        
        if reservation != nil {
            addButton.setTitle("SAVE RESERVATION", for: UIControlState())
            
            startDate = reservation!.startTime as Date
            endDate = reservation!.endTime as Date
            nameTextField.text = reservation!.name
            
            startDateTextLabel.text = String(describing: startDate!.string(custom: customDateString))
            endDateTextLable.text = String(describing: endDate!.string(custom: customDateString))
            notesTextView.text = reservation!.notes
            notesTextView.frame = frameRect
            
            phoneTextField.text = reservation!.phone
        }
        
        personNumberLabel.text = reservation?.person.description
        nameTextField.becomeFirstResponder()
        
        stepper.wraps = false
        stepper.autorepeat = false
        stepper.minimumValue = 1
        stepper.maximumValue = Double(table.limitPersons)
        
        showPopButton.layer.cornerRadius = 15
        addButton.layer.cornerRadius = 15
        
        
        title = table.title()
        
        for textField in textFields {
                textField.inputAccessoryView = accessoryToolbar
        }
        
        currentTextField = textFields.first!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let myColor : UIColor = UIColor.red
        notesTextView.layer.cornerRadius = 25
        nameTextField.layer.borderColor = myColor.cgColor
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func showPop(_ sender: UIButton) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popOver") as! PopOverViewController
        popOverVC.reservation = self.reservation
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    func startDatePickerValueChanged(_ sender: UIDatePicker) {
        startDate = sender.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        startDateTextLabel.text = dateFormatter.string(from: sender.date)
        
    }
    
    func endDatePickerValueChanged(_ sender: UIDatePicker) {
        endDate = sender.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        endDateTextLable.text = dateFormatter.string(from: sender.date)
        
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let index = textFields.index(of: textField)
        
        if index < (textFields.count - 1) {
            let nextTextField = textFields[index! + 1]
            nextTextField.becomeFirstResponder()
            currentTextField = nextTextField
            return false
        } else {
            endDateTextLable.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func addReservation(_ sender: UIButton) {
        
        guard let name = nameTextField.text , name.characters.count > 0 else {
            let alertController = UIAlertController(title: "Validation", message: "PLease type your name", preferredStyle: .alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in }
            self.nameTextField.becomeFirstResponder()
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if startDateTextLabel.text?.characters.count > 0 {
            startDateTextLabel.becomeFirstResponder()
        } else {
            let alertController = UIAlertController(title: "Validation", message: "Input Start Date", preferredStyle: .alert)
            let canselAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in }
            alertController.addAction(canselAction)
            present(alertController, animated: true, completion: nil)
        }
        
        if endDateTextLable.text?.characters.count > 0 {
            endDateTextLable.becomeFirstResponder()
        } else {
            let alertController = UIAlertController(title: "Validation", message: "Input End Date", preferredStyle: .alert)
            let canselAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in }
            alertController.addAction(canselAction)
            present(alertController, animated: true, completion: nil)
        }
        
        if endDate < startDate {
            let alertController = UIAlertController(title: "Validation", message: "Гость не может уйти раньше, чем пришёл", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in }
            self.endDateTextLable.becomeFirstResponder()
            endDate = startDate
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let realm = try! Realm()
        
        realm.beginWrite()
        
        if reservation == nil {
            reservation = Reservation()
            realm.add(reservation!)
            table.reserve(reservation!)
        }
        
        reservation!.name = name
        reservation!.phone = phoneTextField.text!
        reservation!.notes = notesTextView.text!
        reservation!.startTime = startDate!
        reservation!.endTime = endDate!
        reservation!.person = Int(personNumberLabel.text!)!
        
        try! realm.commitWrite()
        
        // TODO: notification должен срабатывать за определённое время
        let notification = UILocalNotification()
        notification.alertBody = "Стол №\(table.name) для \(reservation!.name) заказан через полчаса!"
        notification.alertAction = "open"
        notification.fireDate = startDate
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
        
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
}



