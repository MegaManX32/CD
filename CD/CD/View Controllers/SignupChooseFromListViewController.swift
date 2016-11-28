//
//  SignupChooseFromListViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 11/25/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

enum SelectionType {
    case country
    case city
    case language
    case profession
}

class SignupChooseFromListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    var optionsArray : [AnyObject]!
    var selectionType : SelectionType = .country
    var country : Country!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.selectionType {
        case .country:
            self.optionsArray = Country.findAllCountries(context: CoreDataManager.sharedInstance.mainContext)
            if self.optionsArray.isEmpty {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                NetworkManager.sharedInstance.getAllCountries(success: {
                    self.optionsArray = Country.findAllCountries(context: CoreDataManager.sharedInstance.mainContext)
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }, failure: { (errorMessage) in
                    print(errorMessage)
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            }
        case .city:
            self.optionsArray = City.findAllCities(contryID: self.country.uid!, context: CoreDataManager.sharedInstance.mainContext)
            if self.optionsArray.isEmpty {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                NetworkManager.sharedInstance.getAllCities(country: self.country, success: {
                    self.optionsArray = City.findAllCities(contryID: self.country.uid!, context: CoreDataManager.sharedInstance.mainContext)
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }, failure: { (errorMessage) in
                    print(errorMessage)
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            }
        case .language:
            self.optionsArray = Language.findAllLanguages(context:  CoreDataManager.sharedInstance.mainContext)
            if self.optionsArray.isEmpty {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                NetworkManager.sharedInstance.getAllLanguages(success: {
                    self.optionsArray = Language.findAllLanguages(context:  CoreDataManager.sharedInstance.mainContext)
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }, failure: { (errorMessage) in
                    print(errorMessage)
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            }
        case .profession:
            self.optionsArray = Profession.findAllProfessions(context: CoreDataManager.sharedInstance.mainContext)
            if self.optionsArray.isEmpty {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                NetworkManager.sharedInstance.getAllProfessions(success: {
                    self.optionsArray = Profession.findAllProfessions(context: CoreDataManager.sharedInstance.mainContext)
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }, failure: { (errorMessage) in
                    print(errorMessage)
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            }
        }
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
        
        switch self.selectionType {
        case .city:
            cell.populateCellWithName(name: (self.optionsArray[indexPath.row] as! City).name!)
        case .country:
            cell.populateCellWithName(name: (self.optionsArray[indexPath.row] as! Country).name!)
        case .language:
            cell.populateCellWithName(name: (self.optionsArray[indexPath.row] as! Language).name!)
        case .profession:
            cell.populateCellWithName(name: (self.optionsArray[indexPath.row] as! Profession).profession!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
