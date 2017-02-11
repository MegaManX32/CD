//
//  AboutUsViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 2/11/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - User Actions
    
    @IBAction func openSideMenu(sender: UIButton) {
        self.revealViewController().revealToggle(sender)
    }
}
