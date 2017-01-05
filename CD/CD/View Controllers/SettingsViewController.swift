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

fileprivate let revealWidthOffset: CGFloat = 60
fileprivate let avatarImageViewHeightAndWidth: CGFloat = 60

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var createListOrProvideService : UIButton!
    @IBOutlet weak var hostSwitch : UISwitch!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // set reveal width
        self.revealViewController().rearViewRevealWidth = UIScreen.main.bounds.width - revealWidthOffset
        
        // set avatar
        self.avatarImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        
        let userID = StandardUserDefaults.userID()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.getUser(userID: userID, success: { [unowned self] in
            let context = CoreDataManager.sharedInstance.mainContext
            let user = User.findUserWith(uid: userID, context: context)!
            self.nameLabel.text = user.firstName!
            self.emailLabel.text = user.email!
            if let photoURL = user.photoURL {
                self.avatarImageView.af_setImage(withURL: URL(string: photoURL)!)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { [unowned self] (errorMessage) in
            print(errorMessage)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - User Actions
    
    @IBAction func hostOptionChanged(sender: UISwitch) {
        if !sender.isOn {
            self.createListOrProvideService.setTitle("Create Rider List", for: .normal)
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GuestNavigationController");
            self.revealViewController().pushFrontViewController(controller, animated: true)
        }
        else {
            self.createListOrProvideService.setTitle("Provide Service", for: .normal)
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostNavigationController");
            self.revealViewController().pushFrontViewController(controller, animated: true)
        }
    }
    
    @IBAction func createListOrProvideServiceAction(sender: UIButton) {
        if !self.hostSwitch.isOn {
            let createRiderListController = self.storyboard?.instantiateViewController(withIdentifier: "CreateRiderListViewController")
            self.revealViewController().frontViewController.show(createRiderListController!, sender: self)
            self.revealViewController().revealToggle(self)
        }
        else {
            
        }
    }
    
    @IBAction func profileAction(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostProfileViewController") as! HostProfileViewController
        controller.userID = StandardUserDefaults.userID()
        self.revealViewController().pushFrontViewController(controller, animated: true)
    }
    
    @IBAction func logOut(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
