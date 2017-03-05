//
//  SettingsViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/26/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import AlamofireImage
import MBProgressHUD
import MessageUI

fileprivate let revealWidthOffset: CGFloat = 60
fileprivate let avatarImageViewHeightAndWidth: CGFloat = 60

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var createListOrProvideServiceButton : UIButton!
    @IBOutlet weak var hostSwitch : UISwitch!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // set reveal width
        self.revealViewController().rearViewRevealWidth = UIScreen.main.bounds.width - revealWidthOffset
        
        // set avatar
        self.avatarImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        self.avatarImageView.layer.masksToBounds = true
        
//        let userID = StandardUserDefaults.userID()
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        NetworkManager.sharedInstance.getUser(userID: userID, success: { [unowned self] (userID) in
//            let context = CoreDataManager.sharedInstance.mainContext
//            let user = User.findUserWith(uid: userID, context: context)!
//            self.nameLabel.text = user.firstName!
//            self.emailLabel.text = user.email!
//            if let photoURL = user.photoURL {
//                self.avatarImageView.af_setImage(withURL: URL(string:photoURL)!)
//            }
//            MBProgressHUD.hide(for: self.view, animated: true)
//        }, failure: { [unowned self] (errorMessage) in
//            print(errorMessage)
//            MBProgressHUD.hide(for: self.view, animated: true)
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // update user
        let context = CoreDataManager.sharedInstance.mainContext
        let user = User.findUserWith(uid: StandardUserDefaults.userID(), context: context)!
        self.nameLabel.text = user.firstName!
        self.emailLabel.text = user.email!
        if let photoURL = user.photoURL {
            self.avatarImageView.af_setImage(withURL: URL(string:photoURL)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - User Actions
    
    @IBAction func hostOptionChanged(sender: UISwitch) {
        if !sender.isOn {
            self.createListOrProvideServiceButton.setTitle("Create Rider List", for: .normal)
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GuestNavigationController");
            self.revealViewController().pushFrontViewController(controller, animated: true)
        }
        else {
            self.createListOrProvideServiceButton.setTitle("Provide Service", for: .normal)
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostNavigationController");
            self.revealViewController().pushFrontViewController(controller, animated: true)
        }
    }
    
    @IBAction func createListOrProvideServiceAction(sender: UIButton) {
        if !self.hostSwitch.isOn {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateRiderListViewController") as! CreateRiderListViewController
            if self.revealViewController().frontViewController is GuestHomeViewController {
                self.revealViewController().frontViewController.show(controller, sender: self)
                self.revealViewController().revealToggle(self)
                return
            }
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "GuestNavigationController") as! UINavigationController
            navigationController.pushViewController(controller, animated: false)
            self.revealViewController().pushFrontViewController(navigationController, animated: true)
        }
        else {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostProvideServiceViewController") as! HostProvideServiceViewController
            if self.revealViewController().frontViewController is HostHomeViewController {
                self.revealViewController().frontViewController.show(controller, sender: self)
                self.revealViewController().revealToggle(self)
                return
            }
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "HostNavigationController") as! UINavigationController
            navigationController.pushViewController(controller, animated: false)
            self.revealViewController().pushFrontViewController(navigationController, animated: true)
        }
    }
    
    @IBAction func profileAction(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostProfileViewController") as! HostProfileViewController
        controller.userID = StandardUserDefaults.userID()
        controller.presentFromMainMenu = true
        let navigationController = UINavigationController.init(rootViewController: controller)
        navigationController.isNavigationBarHidden = true
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
    }
    
    @IBAction func homeAction(sender: UIButton) {
        if !self.hostSwitch.isOn {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GuestNavigationController");
            self.revealViewController().pushFrontViewController(controller, animated: true)
        }
        else {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostNavigationController");
            self.revealViewController().pushFrontViewController(controller, animated: true)
        }
    }
    
    @IBAction func logOut(sender : UIButton) {
        
        // do log out
        NetworkManager.sharedInstance.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func aboutUs(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController");
        self.revealViewController().pushFrontViewController(controller, animated: true)
    }
    
    @IBAction func helpAction(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Help")
            mail.setToRecipients(["administrator@custom-deal.com"])
            present(mail, animated: true)
        } else {
            CustomAlert.presentAlert(message: "Please check your email settings", controller: self)
        }
    }
    
    @IBAction func comingSoon(sender: UIButton) {
        CustomAlert.presentAlert(message: "Coming soon :-)", controller: self)
    }
    
    // MARK: - MFMailComposeViewController Methods
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
