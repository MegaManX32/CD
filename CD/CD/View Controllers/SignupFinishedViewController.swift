//
//  SignupFinishedViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 6/21/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit
import CoreData

class SignupFinishedViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    var userID: String!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update welcome label
        let context = CoreDataManager.sharedInstance.mainContext
        let user = User.findUserWith(uid: self.userID, context: context)!
        self.titleLabel.text = "Welcome, " + user.firstName!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func getStarted(sender:UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupAddYourPhotoViewController") as! SignupAddYourPhotoViewController
        controller.userID = self.userID
        self.show(controller, sender: self)
    }
}
