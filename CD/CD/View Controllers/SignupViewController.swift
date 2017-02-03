//
//  SignupViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 6/21/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignupViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var firstNameTextField: IntroTextField!
    @IBOutlet weak var lastNameTextField: IntroTextField!
    @IBOutlet weak var emailTextField: IntroTextField!
    @IBOutlet weak var passwordTextField: IntroTextField!
    @IBOutlet weak var confirmPasswordTextField: IntroTextField!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare text fields
        self.prepareTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Preparation
    
    func prepareTextFields() {
        self.firstNameTextField.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        self.emailTextField.placeholder = NSLocalizedString("Email Address", comment: "Email Address")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
        self.confirmPasswordTextField.placeholder = NSLocalizedString("Confirm Password", comment: "Confirm Password")
        
        self.firstNameTextField.text = "Novak"
        self.lastNameTextField.text = "Djokovic"
        self.emailTextField.text = "novak@gmail.com"
        self.passwordTextField.text = "123456"
        self.confirmPasswordTextField.text = "123456"
    }
    
    // MARK: - User Actions
    
    @IBAction func signupAction() {
        
        // try to create new User
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            // create new user and populate it with data
            let newUser = User(context: context)
            newUser.firstName = self.firstNameTextField.text
            newUser.lastName = self.lastNameTextField.text
            newUser.email = self.emailTextField.text
            newUser.password = self.passwordTextField.text
            
            // create of or update user
            NetworkManager.sharedInstance.createOrUpdate(user: newUser, context: context, success: { [unowned self] (userID) in
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
    
    @IBAction func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
