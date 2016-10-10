//
//  CreateRiderListViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 10/10/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class CreateRiderListViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var genderViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var countryButtonView: ButtonView!
    @IBOutlet weak var cityButtonView: ButtonView!
    @IBOutlet weak var checkInButtonView: ButtonView!
    @IBOutlet weak var checkOutButtonView: ButtonView!
    @IBOutlet weak var genderButtonView: ButtonView!
    @IBOutlet weak var ageButtonView: ButtonView!
    @IBOutlet weak var languageButtonView: ButtonView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // update constraints
        let screenWidth = UIScreen.main.bounds.width
        self.genderViewWidthConstraint.constant = screenWidth / 3 - 12
        self.ageViewWidthConstraint.constant = screenWidth / 3 - 12
        self.languageViewWidthConstraint.constant = screenWidth / 3 - 12
        
        // update button views
        self.countryButtonView.title = NSLocalizedString("Country", comment: "")
        self.cityButtonView.title = NSLocalizedString("City", comment: "")
        self.checkInButtonView.title = NSLocalizedString("Check In", comment: "")
        self.checkOutButtonView.title = NSLocalizedString("Check Out", comment: "")
        self.genderButtonView.title = NSLocalizedString("Gender", comment: "")
        self.ageButtonView.title = NSLocalizedString("Age", comment: "")
        self.languageButtonView.title = NSLocalizedString("Language", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
