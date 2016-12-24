//
//  GuestHomeViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/24/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class GuestHomeViewController: UIViewController {
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func openSideMenu(sender: UIButton) {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(sender)
//            menuButton.target = self.revealViewController()
//            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
