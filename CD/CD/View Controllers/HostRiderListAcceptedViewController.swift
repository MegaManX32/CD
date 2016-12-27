//
//  HostRiderListAcceptedViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/27/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class HostRiderListAcceptedViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var titleLabel : UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User Actions
    
    @IBAction func homeAction(sender: UIButton) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}

