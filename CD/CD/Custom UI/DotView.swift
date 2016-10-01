//
//  DotView.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class DotView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // depending on tag make it selected / unselected
        if (self.tag == 0) {
            self.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        else {
            self.backgroundColor = UIColor.white
        }
        
        self.layer.masksToBounds = true
        
        // needed to calculate the view frame
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.size.width / 2.0
    }

}
