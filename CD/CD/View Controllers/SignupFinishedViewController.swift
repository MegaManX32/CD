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
        
        userID = "26a8d1c4-22e8-4f9b-b88a-351976faba69"
//        let user = User.findUserWith(uid: userID, context: CoreDataManager.sharedInstance.mainContext)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func getStarted(sender:UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupYouLookGoodViewController") as! SignupYouLookGoodViewController
        controller.userID = self.userID
        self.present(controller, animated: true, completion: nil)
    }
}
