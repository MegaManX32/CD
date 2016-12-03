//
//  CreateRiderListViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 10/10/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

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
    
//    var interestsArray : [(name : String, checked : Bool)] = [
//        ("Sport", false),
//        ("Food", false),
//        ("Fashion", false),
//        ("Environment", false),
//        ("Business", false),
//        ("Shopping", false),
//        ("IT", false),
//        ("Art", false),
//        ("Health", false),
//        ("Party", false),
//        ("Science", false),
//        ("Cars", false),
//        ("History", false),
//        ("Music", false),
//        ("Travel", false)
//    ]
    
    var userID : String!
    var interestsArray : [(interest : Interest, checked : Bool)] = [(Interest, Bool)]()
    
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
        
        // fetch interests
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.getAllInterests(
            success: { [unowned self] in
                let context = CoreDataManager.sharedInstance.mainContext
                let interests = Interest.findAllInterests(context: context)
                for interest in interests {
                    self.interestsArray.append((interest, false))
                }
                self.collectionView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            },
            failure: { [unowned self] (errorMessage) in
                print(errorMessage)
                MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func nextAction(sender: UIButton) {
        
        // try to update interests on user
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var selectedInterestsIDArray = [String]()
        for interestOption in self.interestsArray {
            if interestOption.checked {
                selectedInterestsIDArray.append(interestOption.interest.uid!)
            }
        }
        
        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            // find user
            let user = User.findUserWith(uid: self.userID, context: context)!
            
            // update user with interests
            for interestID in selectedInterestsIDArray {
                user.addToInterests(Interest.findInterestWith(id: interestID, context: context)!)
            }
            
            // create of or update user
            NetworkManager.sharedInstance.createOrUpdate(user: user, context: context, success: { [unowned self] (userID) in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupFinishedViewController") as! SignupFinishedViewController
                controller.userID = userID
                self.show(controller, sender: self)
                MBProgressHUD.hide(for: self.view, animated: true)
                }, failure: { [unowned self] (errorMessage) in
                    print(errorMessage)
                    MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
        
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
        cell.populateCellWithInterest(name: self.interestsArray[indexPath.item].interest.name!,
                                      imageName: (self.interestsArray[indexPath.item].interest.name!).lowercased(),
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
