//
//  SignupConfirmPhoneViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/2/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class SignupConfirmPhoneViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var countryCodeLabel: UILabel?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // update label corners
        self.countryCodeLabel?.layer.cornerRadius = 4
        self.countryCodeLabel?.layer.borderWidth = 2
        self.countryCodeLabel?.layer.borderColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
