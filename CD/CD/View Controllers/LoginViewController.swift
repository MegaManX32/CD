//
//  LoginViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/29/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

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
        
        guard let email = self.emailTextField.text//, let password = self.passwordTextField.text
            else {
                CustomAlert.presentAlert(message: "Wrong username or password", controller: self)
                return
        }
        
        // prepare login params
        let params = [
            "email" : email,
//            "password" : password
        ]
        
        // login :-)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.login(params: params, success: {[unowned self] in
            
            NetworkManager.sharedInstance.getLoggedUser(success: {[unowned self] (userID) in
                
                // set user
                StandardUserDefaults.saveUserID(userID: userID)
                
                // get all users
                NetworkManager.sharedInstance.getAllUsers(success: {[unowned self] in
                    
                    // show main controller
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.present(controller, animated: true, completion: nil)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }) {[unowned self] (errorMessage) in
                    print(errorMessage)
                    CustomAlert.presentAlert(message: "Wrong username or password", controller: self)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
            }, failure: {[unowned self] (errorMessage) in
                CustomAlert.presentAlert(message: errorMessage, controller: self)
                MBProgressHUD.hide(for: self.view, animated: true)
            })
            
        }, failure: {[unowned self] (errorMessage) in
            CustomAlert.presentAlert(message: errorMessage, controller: self)
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    @IBAction func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
