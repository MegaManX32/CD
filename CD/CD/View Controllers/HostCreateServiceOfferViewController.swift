//
//  HostCreateServiceOfferViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 1/8/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
fileprivate let sizeOfItem = CGSize.init(width: 300, height: 200)
fileprivate let collectionViewContainerViewDefaultHeight : CGFloat = 200

class HostCreateServiceOfferViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var navigationTitle: String!
    var serviceOfferID: String?
    var photoArray = [String]()
    var photoIDArray = [String]()
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionTextView : UITextView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var collectionViewContainerViewHeight : NSLayoutConstraint!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set proper title
        self.titleLabel.text = self.navigationTitle
        
        // load services if any available
        let user = User.findUserWith(uid: StandardUserDefaults.userID(), context: CoreDataManager.sharedInstance.mainContext)!
        if let serviceOffers = user.serviceOffers as? Set<ServiceOffer> {
            for serviceOffer in serviceOffers {
                if serviceOffer.type == self.navigationTitle.lowercased() {
                    self.serviceOfferID = serviceOffer.uid
                    for index in 0 ..< serviceOffer.photoUrlList!.count {
                        self.photoArray.append(serviceOffer.photoUrlList![index])
                        self.photoIDArray.append(serviceOffer.photoIdList![index])
                    }
                }
            }
        }

        // update collection view presentation
        self.updateCollectionViewPresentationBasedOnPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func updateCollectionViewPresentationBasedOnPhotos() {
        let height = self.photoArray.count == 0 ? 0 : collectionViewContainerViewDefaultHeight
        if self.collectionViewContainerViewHeight.constant != height {
            self.collectionViewContainerViewHeight.constant = height
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - UICollectionViewDelegate methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostProfileCollectionViewCell.cellIdentifier(), for: indexPath) as! HostProfileCollectionViewCell
        cell.populateCellWith(photoURL: self.photoArray[indexPath.item])
        
        // add remove photo action
        cell.cancelPhotoAction = { [unowned self] (cell) in
            let indexPathOfCell = self.collectionView.indexPath(for: cell)!
            self.photoArray.remove(at: indexPathOfCell.row)
            self.photoIDArray.remove(at: indexPathOfCell.row)
            self.collectionView.deleteItems(at: [indexPathOfCell])
            self.updateCollectionViewPresentationBasedOnPhotos()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // right now, do nothing
    }
    
    // MARK: - User Actions
    
    @IBAction func submitAction(sender: UIButton) {
        
        // create new service offer
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            let newServiceOffer = self.serviceOfferID != nil ? ServiceOffer.findServiceOfferWith(id: self.serviceOfferID!, context: context)! : ServiceOffer(context: context)
            newServiceOffer.serviceName = self.titleLabel.text
            newServiceOffer.type = self.titleLabel.text?.lowercased()
            newServiceOffer.desc = self.descriptionTextView.text
            newServiceOffer.userUid = StandardUserDefaults.userID()
            newServiceOffer.photoUrlList = self.photoArray
            newServiceOffer.photoIdList = self.photoIDArray
            
            NetworkManager.sharedInstance.createOrUpdate(serviceOffer: newServiceOffer, type: self.titleLabel.text!.lowercased(), context: context, success: { [unowned self] (serviceOfferID) in
                _ = self.navigationController?.popToRootViewController(animated: true)
                MBProgressHUD.hide(for: self.view, animated: true)
            }, failure: { [unowned self] (errorMessage) in
                print(errorMessage)
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func chooseFromPhotoLibrary(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UINavigationControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        
        // upload image here
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.upload(photo: image, success: { [unowned self] (photoID, photoURL) in
            
            self.photoArray.append(photoURL)
            self.photoIDArray.append(photoID)
            self.collectionView.insertItems(at: [IndexPath.init(row: self.photoArray.count - 1, section: 0)])
            self.updateCollectionViewPresentationBasedOnPhotos()
            MBProgressHUD.hide(for: self.view, animated: true)
            
        }, failure: {[unowned self] (errorMessage) in
            print(errorMessage)
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
