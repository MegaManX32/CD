//
//  HostMakingOfferViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/27/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

class HostMakingOfferViewController: UIViewController {
    
    // MARK: - Properties
    
    var riderListID : String!
    
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
        
        // get currently logged user
        let userID = StandardUserDefaults.userID()
        
        // create offer
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            let riderListOffer = RiderListOffer(context: context)
            riderListOffer.message = self.commentTextView.text
            riderListOffer.price = price as NSNumber?
            riderListOffer.offerorUid = userID
            riderListOffer.riderListId = self.riderListID
            
            NetworkManager.sharedInstance.createOrUpdate(riderListOffer: riderListOffer, context: context, success: { [unowned self] (riderListOfferID) in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostRiderListAcceptedViewController") as! HostRiderListAcceptedViewController
                self.show(controller, sender: self)
                MBProgressHUD.hide(for: self.view, animated: true)
            }, failure: { [unowned self] (errorMessage) in
                print(errorMessage)
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
}
