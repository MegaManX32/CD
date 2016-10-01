//
//  StartViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 6/16/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var facebookButton: UIButton?
    @IBOutlet weak var signUpButton: UIButton?
    @IBOutlet weak var logInButton: UIButton?
    @IBOutlet weak var disclaimerLabel: UILabel?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare labels
        self.prepareLabels()
        
        // prepare buttons
        self.prepareButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Preparation
    
    func prepareButtons() {
        
        self.facebookButton?.layer.masksToBounds = true
        self.facebookButton?.layer.cornerRadius = 4
        self.facebookButton?.layer.borderColor = UIColor.white.cgColor
        self.facebookButton?.layer.borderWidth = 1
        
        self.signUpButton?.layer.masksToBounds = true
        self.signUpButton?.layer.cornerRadius = 4
        self.signUpButton?.layer.borderColor = UIColor.white.cgColor
        self.signUpButton?.layer.borderWidth = 1
        
        self.logInButton?.layer.masksToBounds = true
        self.logInButton?.layer.cornerRadius = 4
        self.logInButton?.layer.borderColor = UIColor.white.cgColor
        self.logInButton?.layer.borderWidth = 1
        
    }
    
    func prepareLabels() {
        
        // prepare fonts
        let normalFont = UIFont(name: "Roboto-Regular", size: 24)!
        let boldFont = UIFont(name: "Roboto-Bold", size: 24)!
        
        // prepare title label text
        let titleLabelAttributedText = NSMutableAttributedString(string: "INCREASE YOUR ", attributes: [NSFontAttributeName : normalFont])
        titleLabelAttributedText.append(NSMutableAttributedString(string: "INCOME", attributes: [NSFontAttributeName : boldFont]))
        titleLabelAttributedText.append(NSMutableAttributedString(string: "\nBY OFFERING SERVICES\nOR\nJUST BE A ", attributes: [NSFontAttributeName : normalFont]))
        titleLabelAttributedText.append(NSMutableAttributedString(string: "CELEBRITY", attributes: [NSFontAttributeName : boldFont]))
        titleLabelAttributedText.append(NSMutableAttributedString(string: "\nAND CREATE YOUR", attributes: [NSFontAttributeName : normalFont]))
        titleLabelAttributedText.append(NSMutableAttributedString(string: "\nRIDER LIST", attributes: [NSFontAttributeName : boldFont]))
        
        // setup label
        self.titleLabel?.attributedText = titleLabelAttributedText
        self.titleLabel?.numberOfLines = 6
        
        // setup disclaimer label
        self.disclaimerLabel?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
    }
}
