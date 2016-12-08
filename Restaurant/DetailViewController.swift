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


class DetailViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var startDateTextLabel: UITextField!
    @IBOutlet weak var endDateTextLable: UITextField!    
    @IBOutlet weak var addButton: UIButton!    
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var personNumberLabel: UILabel!
    @IBOutlet weak var callTextLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperAction(_ sender: UIStepper) {
        personNumberLabel.text = "\(Int(stepper.value))"
    }

    @IBAction func makeCall(sender: UIButton) {
        callNumber(phoneNumber: (callTextLabel?.text!)!)
    }
    
   
    var currentTextField: UIView!
        
    var startDate: Date?
    var endDate: Date?
    
    var table: Table!
    var reservation: Reservation?
    let customDateString = "YYYY.MM.dd, HH:mm"
    
    lazy var accessoryToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolbar.barStyle = UIBarStyle.blackOpaque
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
        if let tf = currentTextField as? UITextField {
            _ = textFieldShouldReturn(tf)
        } else {
            
        }
    }
    
    lazy var textFields: [UIView] = {
        return [self.nameTextField, self.startDateTextLabel, self.endDateTextLable, self.notesTextView, self.phoneTextField]
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
            callTextLabel.text = "\(phoneTextField!.text!)"
        }
        
        personNumberLabel.text = "1" //reservation?.person.description
        nameTextField.becomeFirstResponder()
        stepper.wraps = false
        stepper.autorepeat = false
        stepper.minimumValue = 1
        stepper.maximumValue = Double(table.limitPersons)
        
        title = table.title()
        
        for textField in textFields {
            if let tf = textField as? UITextField {
                tf.inputAccessoryView = accessoryToolbar
            }
        }
        currentTextField = textFields.first!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var index = 0 as Int
        let formattedString = NSMutableString()
        if textField == phoneTextField {
        let text: NSString = (phoneTextField.text ?? "") as NSString
        callTextLabel.text = text.replacingCharacters(in: range, with: string)
            formattedString.append(text as String)
            index += 1
        }
        return true
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
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        if (textField == phoneTextField)
//        {
//            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
//            
//            let decimalString = components.joined(separator: "") as NSString
//            let length = decimalString.length
//            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
//            
//            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
//            {
//                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
//                
//                return (newLength > 10) ? false : true
//            }
//            var index = 0 as Int
//            let formattedString = NSMutableString()
//            
//            if hasLeadingOne
//            {
//                formattedString.append("1")
//                index += 1
//            }
//            if (length - index) > 3
//            {
//                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
//                formattedString.appendFormat("%@", areaCode)
//                index += 3
//            }
//            if length - index > 3
//            {
//                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
//                formattedString.appendFormat("%@", prefix)
//                index += 3
//            }
//            if length - index > 3
//            {
//                let prefix = decimalString.substring(with: NSMakeRange(index, 2))
//                formattedString.appendFormat("%@", prefix)
//                index += 2
//            }
//            
//            let remainder = decimalString.substring(from: index)
//            formattedString.append(remainder)
//            textField.text = formattedString as String
//            return false
//        }
//        else
//        {
//            return true
//        }
//    }
    
    //TODO: сделать правильный returner
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let index = textFields.index(of: textField)
        
        if index < (textFields.count - 1) {  
            let nextTextField = textFields[index! + 1]
            nextTextField.becomeFirstResponder()
            currentTextField = nextTextField
            return false
        } else {
            notesTextView.resignFirstResponder()
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
//        guard let person = Int(personsTextField.text!) , person <= table.limitPersons else {
//            let alertController = UIAlertController(title: "Validation", message: "The number of guest may be less than \(table.limitPersons) ", preferredStyle: .alert)
//        
//            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in }
//                self.personsTextField.becomeFirstResponder()
//                alertController.addAction(cancelAction)
//                present(alertController, animated: true, completion: nil)
//                return
//        }
        
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
        notification.alertBody = "Стол для \(reservation!.name) заказан через полчаса!"
        notification.alertAction = "open"
        notification.fireDate = startDate
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
        
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
}
    
    
    

