//
//  EditProfileViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 3/4/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol EditProfileViewControllerDelegate: class {
    func editProfileViewControllerDidFinish(controller: EditProfileViewController)
}

class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var firstNameTextField: IntroTextField!
    @IBOutlet weak var lastNameTextField: IntroTextField!
    @IBOutlet weak var aboutTextView: UITextView!
    
    var userID: String!
    weak var delegate: EditProfileViewControllerDelegate?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user
        let user = User.findUserWith(uid: self.userID, context: CoreDataManager.sharedInstance.mainContext)!
        
        // prepare first and last name
        self.firstNameTextField.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.firstNameTextField.text = user.firstName
        self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        self.lastNameTextField.text = user.lastName
        self.aboutTextView.text = user.aboutUser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    @IBAction func changeAvatar(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "EditProfilePhotoViewController") as! EditProfilePhotoViewController
        controller.userID = self.userID
        self.show(controller, sender: self)
    }
    
    @IBAction func backAction(sender: UIButton) {
        self.delegate?.editProfileViewControllerDidFinish(controller: self)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func transportationAction(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostCreateServiceOfferViewController") as! HostCreateServiceOfferViewController
        controller.navigationTitle = "Transportation"
        self.show(controller, sender: self)
    }
    
    @IBAction func accomodationAction(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostCreateServiceOfferViewController") as! HostCreateServiceOfferViewController
        controller.navigationTitle = "Accommodation"
        self.show(controller, sender: self)
    }
    
    @IBAction func save(sender: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            // get user
            let user = User.findUserWith(uid: self.userID, context: context)!
            user.firstName = self.firstNameTextField.text
            user.lastName = self.lastNameTextField.text
            user.aboutUser = self.aboutTextView.text
            
            NetworkManager.sharedInstance.createOrUpdate(user: user, context: context, success: { [unowned self] (userID) in
                self.delegate?.editProfileViewControllerDidFinish(controller: self)
                _ = self.navigationController?.popViewController(animated: true)
                MBProgressHUD.hide(for: self.view, animated: true)
            }, failure: {[unowned self] (errorMessage) in
                print(errorMessage)
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
}
