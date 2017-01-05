//
//  HostProfileCollectionViewCell.swift
//  CD
//
//  Created by Vladislav Simovic on 12/29/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class HostProfileCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Helper methods
    
    func populateCellWith(photoURL : String?) {
        if let photoURL = photoURL {
            self.photoImageView.af_setImage(withURL: URL(string: photoURL)!)
        }
        self.nameLabel.text = ""
    }
    
    // MARK: - Type methods
    
    class func cellIdentifier() -> String {
        return String(describing:self)
    }
}
