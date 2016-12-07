//
//  SignupYouLookGoodViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate let imageWidth: CGFloat = 107

class SignupYouLookGoodViewController: UIViewController {
    
    // MARK: - Properties
    
    var userID : String!
    var avatarImage : UIImage!
    
    @IBOutlet weak var avatarImageView : UIImageView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add avatar
        self.avatarImageView.layer.cornerRadius = imageWidth / 2.0
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.image = self.avatarImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func nextAction(sender: UIButton) {
        
        // try to upload photo on user
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.upload(photo: avatarImage, success: {(photoID) in
            
            let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
            context.perform {
                [unowned self] in
                
                // find user
                let user = User.findUserWith(uid: self.userID, context: context)!
                user.photoId = photoID
                
                // create of or update user
                NetworkManager.sharedInstance.createOrUpdate(user: user, context: context, success: { [unowned self] (userID) in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupCountryViewController") as! SignupCountryViewController
                    controller.userID = userID
                    self.show(controller, sender: self)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    }, failure: { [unowned self] (errorMessage) in
                        print(errorMessage)
                        MBProgressHUD.hide(for: self.view, animated: true)
                })
            }
            
            
        }) { (errorMessage) in
            print(errorMessage)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @IBAction func changePhotoAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
