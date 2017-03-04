//
//  EditProfilePhotoViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 3/4/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol EditProfilePhotoViewControllerDelegate: class {
    func editProfilePhotoViewControllerDidFinish(controller: EditProfilePhotoViewController)
}

class EditProfilePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    var userID: String!
    weak var delegate: EditProfilePhotoViewControllerDelegate?
    @IBOutlet weak var avatarImageView: UIImageView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user
        let user = User.findUserWith(uid: self.userID, context: CoreDataManager.sharedInstance.mainContext)!
        
        // prepare avatar
        self.avatarImageView.layer.cornerRadius = 130 / 2.0
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.borderWidth = 2.0
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        if let photoURL = user.photoURL {
            self.avatarImageView.af_setImage(withURL: URL(string: photoURL)!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
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
    
    @IBAction func saveAction(sender: UIButton) {
        
        // try to upload photo on user
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.upload(photo: self.avatarImageView.image!, success: {[unowned self] (photoID, photoURL) in
            
            let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
            context.perform {
                [unowned self] in
                
                // find user
                let user = User.findUserWith(uid: self.userID, context: context)!
                user.photoId = photoID
                user.photoURL = photoURL
                
                // create of or update user
                NetworkManager.sharedInstance.createOrUpdate(user: user, context: context, success: { [unowned self] (userID) in
                    self.delegate?.editProfilePhotoViewControllerDidFinish(controller: self)
                    _ = self.navigationController?.popViewController(animated: true)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    }, failure: { [unowned self] (errorMessage) in
                        print(errorMessage)
                        MBProgressHUD.hide(for: self.view, animated: true)
                })
            }
            
            
            }, failure: {[unowned self] (errorMessage) in
                print(errorMessage)
                MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        self.avatarImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
