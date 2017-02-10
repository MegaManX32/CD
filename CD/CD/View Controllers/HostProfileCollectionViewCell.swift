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
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var cancelButton: UIButton!
    var cancelPhotoAction: ((HostProfileCollectionViewCell) -> ())?
    
    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // make cancel button rounded
        cancelButton.layer.cornerRadius = 40 / 2
        cancelButton.layer.masksToBounds = true
    }
    
    // MARK: - Helper Methods
    
    func populateCellWith(photoURL : String?) {
        if let photoURL = photoURL {
            self.photoImageView.af_setImage(withURL: URL(string: photoURL)!)
        }
        self.nameLabel?.text = ""
    }
    
    // MARK: - Type Methods
    
    class func cellIdentifier() -> String {
        return String(describing:self)
    }
    
    // MARK: - User Actions
    
    @IBAction func cancelAction(sender: UIButton) {
        self.cancelPhotoAction?(self)
    }
}
