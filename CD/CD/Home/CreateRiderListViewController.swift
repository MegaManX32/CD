//
//  CreateRiderListViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 10/10/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 10.0, right: 20.0)
fileprivate let itemsPerRow: CGFloat = 3

class CreateRiderListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    @IBOutlet weak var genderViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var countryButtonView: ButtonView!
    @IBOutlet weak var cityButtonView: ButtonView!
    @IBOutlet weak var checkInButtonView: ButtonView!
    @IBOutlet weak var checkOutButtonView: ButtonView!
    @IBOutlet weak var genderButtonView: ButtonView!
    @IBOutlet weak var ageButtonView: ButtonView!
    @IBOutlet weak var languageButtonView: ButtonView!
    
    @IBOutlet weak var riderListTextView: UITextView!
    
    var interestsArray : [(name : String, checked : Bool)] = [
        ("Sport", false),
        ("Food", false),
        ("Fashion", false),
        ("Environment", false),
        ("Business", false),
        ("Shopping", false),
        ("IT", false),
        ("Art", false),
        ("Health", false),
        ("Party", false),
        ("Science", false),
        ("Cars", false),
        ("History", false),
        ("Music", false),
        ("Travel", false)
    ]
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // update constraints
        let screenWidth = UIScreen.main.bounds.width
        self.genderViewWidthConstraint.constant = screenWidth / 3 - 12
        self.ageViewWidthConstraint.constant = screenWidth / 3 - 12
        self.languageViewWidthConstraint.constant = screenWidth / 3 - 12
        
        // update button views
        self.countryButtonView.title = NSLocalizedString("Country", comment: "")
        self.cityButtonView.title = NSLocalizedString("City", comment: "")
        self.checkInButtonView.title = NSLocalizedString("Check In", comment: "")
        self.checkOutButtonView.title = NSLocalizedString("Check Out", comment: "")
        self.genderButtonView.title = NSLocalizedString("Gender", comment: "")
        self.ageButtonView.title = NSLocalizedString("Age", comment: "")
        self.languageButtonView.title = NSLocalizedString("Language", comment: "")
        
        // update text view
        self.riderListTextView.layer.masksToBounds = true
        self.riderListTextView.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDelegate methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.interestsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignupInterestsCollectionViewCell.cellIdentifier(), for: indexPath) as! SignupInterestsCollectionViewCell
        cell.populateCellWithInterest(name: self.interestsArray[indexPath.item].name,
                                      imageName: (self.interestsArray[indexPath.item].name).lowercased(),
                                      checked: self.interestsArray[indexPath.item].checked
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.interestsArray[indexPath.item].checked = !self.interestsArray[indexPath.item].checked
        self.collectionView.reloadItems(at: [indexPath])
    }

}
