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

class DetailViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var personsTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var startDateTextLabel: UITextField!
    @IBOutlet weak var endDateTextLable: UITextField!    
    @IBOutlet weak var addButton: UIButton!    
    @IBOutlet weak var imageViewLabel: UIImageView!
    
    var currentTextField: UITextField!
    
    var startDate: NSDate?
    var endDate: NSDate?
    
    var table: Table!
    var reservation: Reservation?
    
    lazy var accessoryToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        toolbar.barStyle = UIBarStyle.Default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailViewController.cancelDidPressed)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailViewController.doneDidPressed))]
        toolbar.sizeToFit()
        return toolbar
    }()
    
    func cancelDidPressed() {
        view.endEditing(true)
    }
    
    func doneDidPressed() {
        textFieldShouldReturn(currentTextField)
    }
    
    
    lazy var textFields: [UITextField] = {
        return [self.nameTextField, self.personsTextField, self.startDateTextLabel, self.endDateTextLable, self.phoneTextField, self.notesTextField]
    }()

    @IBAction func startDateTextLabel(sender: UITextField) {
        let startDatePickerView:UIDatePicker = UIDatePicker()
        
        startDatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = startDatePickerView
        
        startDatePickerView.addTarget(self, action: #selector(DetailViewController.startDatePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

    }

    @IBAction func endDateTextLable(sender: UITextField) {
        let endDatePickerView:UIDatePicker = UIDatePicker()
        endDatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = endDatePickerView
        
        endDatePickerView.addTarget(self, action: #selector(DetailViewController.endDatePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if reservation != nil {
            addButton.setTitle("SAVE RESERVATION", forState: .Normal)
            
            startDate = reservation!.startTime
            endDate = reservation!.endTime
            nameTextField.text = reservation!.name
            personsTextField.text = String(reservation!.person)
            startDateTextLabel.text = startDate!.toString()
            endDateTextLable.text = endDate!.toString()
            notesTextField.text = reservation!.notes
            phoneTextField.text = reservation!.phone
            
        }
        
        nameTextField.becomeFirstResponder()
        
        title = table.title()
        
        for textField in textFields {
            textField.inputAccessoryView = accessoryToolbar
        }
        
        currentTextField = textFields.first!
        
    }
    
        
    func startDatePickerValueChanged(sender:UIDatePicker) {
        startDate = sender.date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        startDateTextLabel.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func endDatePickerValueChanged(sender:UIDatePicker) {
        endDate = sender.date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        endDateTextLable.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == phoneTextField)
        {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@ ", prefix)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 2))
                formattedString.appendFormat("%@ ", prefix)
                index += 2
            }
            
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        else
        {
            return true
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let index = textFields.indexOf(textField)
        
        if index < (textFields.count - 1) {  
            let nextTextField = textFields[index!+1]
            nextTextField.becomeFirstResponder()
            currentTextField = nextTextField
            return false
        } else {
            notesTextField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func addReservation(sender: UIButton) {
        
        guard let name = nameTextField.text where name.characters.count > 0 else {
            let alertController = UIAlertController(title: "Validation", message: "PLease type your name", preferredStyle: .Alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
            self.nameTextField.becomeFirstResponder()
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        guard let person = Int(personsTextField.text!) where person <= table.limitPersons else {
            let alertController = UIAlertController(title: "Validation", message: "The number of guest may be less than \(table.limitPersons) ", preferredStyle: .Alert)
        
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
                self.personsTextField.becomeFirstResponder()
                alertController.addAction(cancelAction)
                presentViewController(alertController, animated: true, completion: nil)
                return
        }
        
        if endDate < startDate {
            let alertController = UIAlertController(title: "Validation", message: "EndDate < StartDate", preferredStyle: .Alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
            self.endDateTextLable.becomeFirstResponder()
            endDate = startDate
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        if startDateTextLabel.text?.characters.count > 0 {
            startDateTextLabel.becomeFirstResponder()
        } else {
            let alertController = UIAlertController(title: "Validation", message: "Input Start Date", preferredStyle: .Alert)
            let canselAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in }
            alertController.addAction(canselAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        if endDateTextLable.text?.characters.count > 0 {
            endDateTextLable.becomeFirstResponder()
        } else {
            let alertController = UIAlertController(title: "Validation", message: "Input End Date", preferredStyle: .Alert)
            let canselAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in }
            alertController.addAction(canselAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        let pers : UITextField = personsTextField
        let placeholder = NSAttributedString(string: "Some", attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
        pers.attributedPlaceholder = placeholder
        
        let realm = try! Realm()

        realm.beginWrite()

        if reservation == nil {
            reservation = Reservation()
            realm.add(reservation!)
            table.reserve(reservation!)
        }

        reservation!.name = name
        reservation!.person = person
        reservation!.phone = phoneTextField.text!
        reservation!.notes = notesTextField.text!
        reservation!.startTime = startDate!
        reservation!.endTime = endDate!
        
        try! realm.commitWrite()
        
        navigationController?.popViewControllerAnimated(true)
        
    }
}
    
    
    

