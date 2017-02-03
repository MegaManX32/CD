//
//  SignupYourInterestsViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 30.0, right: 20.0)
fileprivate let itemsPerRow: CGFloat = 3
fileprivate let heightOfRow: CGFloat = 100

class SignupYourInterestsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var userID : String!
    var interestsArray : [(interest : Interest, checked : Bool)] = [(Interest, Bool)]()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        var selectedInterestsIDArray = [String]()
        for interestOption in self.interestsArray {
            if interestOption.checked {
                selectedInterestsIDArray.append(interestOption.interest.uid!)
            }
        }
        
        // at least 3 interests must be selected
        if selectedInterestsIDArray.count < 4 {
            CustomAlert.presentAlert(message: "At least 4 interests must be selected", controller: self)
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
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
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupCongratulationsViewController") as! SignupCongratulationsViewController
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
        return CGSize(width: widthPerItem, height: heightOfRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.interestsArray[indexPath.item].checked = !self.interestsArray[indexPath.item].checked
        self.collectionView.reloadItems(at: [indexPath])
    }
}
