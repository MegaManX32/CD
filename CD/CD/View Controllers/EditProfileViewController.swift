//
//  EditProfileViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 3/4/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var firstNameTextField: IntroTextField!
    @IBOutlet weak var lastNameTextField: IntroTextField!
    @IBOutlet weak var aboutTextView: UITextView!
    
    var userID: String!
    
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
        
        // prepare first and last name
        self.firstNameTextField.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.firstNameTextField.text = user.firstName
        self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        self.lastNameTextField.text = user.lastName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func changeAvatar(sender: UIButton) {
        
    }
    
    @IBAction func backAction(sender: UIButton) {
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
    
    }
}
