//
//  IntroTextField.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 6/21/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class IntroTextField: UITextField {
    
    // MARK: - Properties
    
    override var placeholder: String? {
        didSet {
            
            // set placeholder color
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                            attributes: [NSForegroundColorAttributeName:UIColor(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1)])
        }
    }
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1)
        self.font = UIFont(name: "Roboto-Regular", size: 14)!
        self.textColor = UIColor.white
    }

}
