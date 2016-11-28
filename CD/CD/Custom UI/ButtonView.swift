//
//  ButtonView.swift
//  CD
//
//  Created by Vladislav Simovic on 10/10/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let leftTextPadding: CGFloat = 10
fileprivate let rightImagePadding: CGFloat = 10
fileprivate let imageWidth: CGFloat = 20

class ButtonView: UIView {
    
    // MARK: - Properties
    
    var action:(() -> ())?
    var title: String?
    var hasImage: Bool?
    var isWhite = false
    
    private let titleLabel = UILabel.init()
    private let imageView = UIImageView.init(image: UIImage.init(named: "forwardIcon"))
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel.font = UIFont(name: "Roboto-Light", size: 14)!
        self.titleLabel.textColor = UIColor(colorLiteralRed: 86 / 255.0, green: 90 / 255.0, blue: 92 / 255.0, alpha: 1)
        self.addSubview(self.titleLabel)
        
        self.imageView.contentMode = .center
        self.imageView.tintColor = UIColor(colorLiteralRed: 86 / 255.0, green: 90 / 255.0, blue: 92 / 255.0, alpha: 1)
        self.addSubview(self.imageView)
        
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(actionOnPress))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.text = self.title
        self.imageView.isHidden = false
        
        // update for white version
        if isWhite {
            self.backgroundColor = .clear
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 1
            self.imageView.tintColor = .white
            self.titleLabel.textColor = .white
        }
        
        // update frames
        self.titleLabel.frame = CGRect.init(x: leftTextPadding, y: 0, width: self.frame.width - self.frame.height, height: self.frame.height)
        self.imageView.frame = CGRect.init(x: self.frame.width - imageWidth - rightImagePadding, y: 0, width: imageWidth, height: self.frame.height)
    }
    
    // MARK: - User actions
    
    func actionOnPress() {
        if let newAction = self.action {
            newAction()
        }
    }
    
}
