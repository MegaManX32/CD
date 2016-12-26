//
//  SettingsViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/26/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let revealWidthOffset: CGFloat = 60

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // set reveal width
        self.revealViewController().rearViewRevealWidth = UIScreen.main.bounds.width - revealWidthOffset
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
