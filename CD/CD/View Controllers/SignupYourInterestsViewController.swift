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

class SignupYourInterestsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView : UICollectionView!
    
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
    
    var interestsArray : [(interest : Interest, checked : Bool)] = [(Interest, Bool)]()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch interests
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.getAllInterests(
            success: { [unowned self] (interests) in
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
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.interestsArray[indexPath.item].checked = !self.interestsArray[indexPath.item].checked
        self.collectionView.reloadItems(at: [indexPath])
    }
}
