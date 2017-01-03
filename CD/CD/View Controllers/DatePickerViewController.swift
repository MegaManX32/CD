//
//  DatePickerViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/3/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var datePicker : UIDatePicker!
    var pickedDate : Date?
    var datePickedAction : ((Date) -> ())?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set date picker to be white color
        self.datePicker.setValue(UIColor.white, forKey: "textColor")
        
        // set picked date
        if let date = self.pickedDate {
            self.datePicker.date = date
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func ok(sender: UIButton) {
        self.datePickedAction?(self.datePicker.date)
    }
    
    @IBAction func cancel(sender: UIButton) {
        
    }
}
