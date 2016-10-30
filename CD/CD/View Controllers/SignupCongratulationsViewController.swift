//
//  SignupCongratulationsViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 10/3/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class SignupCongratulationsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var subtitleLabel : UILabel!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // personalize message
        self.subtitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("%@, your profile is awesome.", comment: "your profile is awesome"), "Branko")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
