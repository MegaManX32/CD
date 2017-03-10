//
//  SignupCongratulationsViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 10/3/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignupCongratulationsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var subtitleLabel : UILabel!
    var userID : String!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // save logged user
        StandardUserDefaults.saveUserID(userID: self.userID)
        
        // show personalized congrats message
        let mainContext = CoreDataManager.sharedInstance.mainContext
        let user = User.findUserWith(uid: self.userID, context: mainContext)!
        self.subtitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("%@, your profile is awesome.", comment: "your profile is awesome"), user.firstName!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func homeAction(sender: UIButton) {
        self.loginAction()
    }
    
    func loginAction() {
        
        // get user
        let mainContext = CoreDataManager.sharedInstance.mainContext
        let user = User.findUserWith(uid: self.userID, context: mainContext)!
        
        // prepare login params
        let params = [
            "email" : user.email!,
            "password" : user.password!
        ]
        
        // login :-)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.logout()
        NetworkManager.sharedInstance.login(params: params, success: {
            [unowned self] in
            
            // get user data
            NetworkManager.sharedInstance.getLoggedUser(success: {[unowned self] (userID) in
                
                // set user
                StandardUserDefaults.saveUserID(userID: userID)
                
                // show reveal view controller
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.present(controller, animated: true, completion: {
                    [unowned self] in
                    _ = self.navigationController?.popToRootViewController(animated: false)
                })
                MBProgressHUD.hide(for: self.view, animated: true)
                
                }, failure: {[unowned self] (errorMessage) in
                    CustomAlert.presentAlert(message: errorMessage, controller: self)
                    MBProgressHUD.hide(for: self.view, animated: true)
            })
            
            }, failure: {[unowned self] (errorMessage) in
                CustomAlert.presentAlert(message: errorMessage, controller: self)
                MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
}
