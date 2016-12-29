//
//  LoginViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/29/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var emailTextField: IntroTextField!
    @IBOutlet weak var passwordTextField: IntroTextField!
    
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
        self.emailTextField.placeholder = NSLocalizedString("Email Address", comment: "Email Address")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password")
    }
    
    // MARK: - User Actions
    
    @IBAction func loginAction() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
