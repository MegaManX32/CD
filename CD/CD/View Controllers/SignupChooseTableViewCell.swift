//
//  SignupChooseTableViewCell.swift
//  CD
//
//  Created by Vladislav Simovic on 11/28/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class SignupChooseTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Helper methods
    
    func populateCellWithName(name:String) {
        self.titleLabel.text = name
    }
    
    // MARK: - Type methods
    
    class func cellIdentifier() -> String {
        return String(describing:self)
    }
}
