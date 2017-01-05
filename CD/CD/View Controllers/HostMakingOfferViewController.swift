//
//  HostMakingOfferViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/27/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class HostMakingOfferViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var priceTextField : UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // update content view and its subviews
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 4
        self.priceTextField.keyboardType = .numberPad
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(sender: UIButton) {
        
        // simple validation
        guard let priceText = self.priceTextField?.text, let price = Int(priceText)
            else {
                CustomAlert.presentAlert(message: "You must enter valid price", controller: self)
                return
        }
        print(price)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostRiderListAcceptedViewController") as! HostRiderListAcceptedViewController
        self.show(controller, sender: self)
    }
}
