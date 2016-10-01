//
//  IntroButtonWhite.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class IntroButtonWhite: UIButton {

    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.clear
        self.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)!
        self.setTitleColor(UIColor.white, for: UIControlState())
    }
}
