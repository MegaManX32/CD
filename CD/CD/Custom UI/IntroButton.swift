//
//  IntroButton.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 6/21/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class IntroButton: UIButton {
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor(colorLiteralRed: 1, green: 81 / 255.0, blue: 96 / 255.0, alpha: 1)
        self.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)!
        self.setTitleColor(UIColor.white, for: UIControlState())
    }
}
