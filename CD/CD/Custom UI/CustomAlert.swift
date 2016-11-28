//
//  CustomAlert.swift
//  CD
//
//  Created by Vladislav Simovic on 11/28/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class CustomAlert {

    // MARK: - Action methods
    
    static func presentAlert(message: String, controller : UIViewController) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
