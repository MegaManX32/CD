//
//  SignupViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 6/21/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

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
        
        self.firstNameTextField.placeholder = "Vlado"
        self.lastNameTextField.placeholder = "Simovic"
        self.emailTextField.placeholder = "vlado@gmail.com"
        self.passwordTextField.placeholder = "123456"
        self.confirmPasswordTextField.placeholder = "123456"
    }
    
    // MARK: - User Actions
    
    @IBAction func signupAction() {
        
        // try to create new User
        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            // create new user and populate it with data
            let newUser = User(context: context)
            newUser.firstName = self.firstNameTextField.text
            newUser.lastName = self.lastNameTextField.text
            newUser.email = self.emailTextField.text
            newUser.password = self.passwordTextField.text
            
            NetworkManager.sharedInstance.createOrUpdate(user: newUser, success: { (user) in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "SignupFinishedSegue", sender: self)
                }
            }, failure: { (errorMessage) in
                DispatchQueue.main.async {
                    print("some error")
                }
            })
        }
    }
    
    @IBAction func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
