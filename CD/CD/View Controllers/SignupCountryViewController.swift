//
//  SignupCountryViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class SignupCountryViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var countryTextField: IntroTextField!
    @IBOutlet weak var cityTextField: IntroTextField!
    @IBOutlet weak var zipCodeField: IntroTextField!
    @IBOutlet weak var professionTextField: IntroTextField!
    @IBOutlet weak var languageTextField: IntroTextField!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare text fields
        self.prepareTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - View Preparation
    
    func prepareTextFields() {
        self.countryTextField.placeholder = NSLocalizedString("Country", comment: "country")
        self.cityTextField.placeholder = NSLocalizedString("City", comment: "city")
        self.zipCodeField.placeholder = NSLocalizedString("Zip code", comment: "zip code")
        self.professionTextField.placeholder = NSLocalizedString("Profession", comment: "profession")
        self.languageTextField.placeholder = NSLocalizedString("Language", comment: "language")
    }

}
