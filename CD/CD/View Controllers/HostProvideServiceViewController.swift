//
//  HostProvideServiceViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 1/8/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

import UIKit

class HostProvideServiceViewController: UIViewController {
    
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
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func transportationAction(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostCreateServiceOfferViewController") as! HostCreateServiceOfferViewController
        controller.navigationTitle = "Transportation"
        self.show(controller, sender: self)
    }
    
    @IBAction func accomodationAction(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostCreateServiceOfferViewController") as! HostCreateServiceOfferViewController
        controller.navigationTitle = "Accommodation"
        self.show(controller, sender: self)
    }

}
