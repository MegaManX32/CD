//
//  SignupChooseFromListViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 11/25/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

enum SelectionType {
    case city
    case country
    case language
    case profession
}

class SignupChooseFromListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    var optionsArray : [AnyObject]!
    var selection : SelectionType!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:SignupChooseTableViewCell.cellIdentifier(), for: indexPath) as! SignupChooseTableViewCell
        
        cell.populateCellWithName(name: "Some Name")
        
//        switch self.selection {
//        case city:
//        case country:
//        case language:
//        case profession:
        
        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
