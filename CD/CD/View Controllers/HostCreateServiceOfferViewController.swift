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

class HostCreateServiceOfferViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var navigationTitle : String!
    var photoArray = ["http://www.moibbk.com/images/bmw-6-series-red-11.jpg", "http://cdn.bmwblog.com/wp-content/uploads/2015-BMW-6-Series-Convertible-15-750x562.jpg"]
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionTextView : UITextView!
    @IBOutlet weak var collectionView : UICollectionView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set proper title
        self.titleLabel.text = self.navigationTitle
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
        return self.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostProfileCollectionViewCell.cellIdentifier(), for: indexPath) as! HostProfileCollectionViewCell
        cell.populateCellWith(photoURL: self.photoArray[indexPath.item])
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
            self.collectionView.insertItems(at: [IndexPath.init(row: self.photoArray.count - 1, section: 0)])
            
        }, failure: {[unowned self] (errorMessage) in
            print(errorMessage)
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
