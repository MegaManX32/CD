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
    
    @IBOutlet weak var countryButtonView: ButtonView!
    @IBOutlet weak var cityButtonView: ButtonView!
    @IBOutlet weak var zipCodeButtonView: ButtonView!
    @IBOutlet weak var professionButtonView: ButtonView!
    @IBOutlet weak var languageButtonView: ButtonView!
    
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
        self.countryButtonView.title = NSLocalizedString("Country", comment: "country")
        self.countryButtonView.isWhite = true
        self.cityButtonView.title = NSLocalizedString("City", comment: "city")
        self.cityButtonView.isWhite = true
//        self.zipCodeField.placeholder = NSLocalizedString("Zip code", comment: "zip code")
        self.professionButtonView.title = NSLocalizedString("Profession", comment: "profession")
        self.professionButtonView.isWhite = true
        self.languageButtonView.title = NSLocalizedString("Language", comment: "language")
        self.languageButtonView.isWhite = true
    }

}
