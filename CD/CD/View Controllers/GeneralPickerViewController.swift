//
//  GeneralPickerViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/3/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

enum SelectionType {
    case country
    case city
    case profession
    case gender
    case age
}

protocol GeneralPickerViewControllerDelegate {
    func generalPickerViewControllerDidSelect(object: Any, selectionType: SelectionType, controller: UIViewController);
}

class GeneralPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    var delegate : GeneralPickerViewControllerDelegate?
    var optionsArray = [Any]()
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
        case .gender:
            self.optionsArray = ["Male", "Female"]
        case .age:
            for index in 18...100 {
                self.optionsArray.append("\(index)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier:GeneralPickerTableViewCell.cellIdentifier(), for: indexPath) as! GeneralPickerTableViewCell
        
        switch self.selectionType {
        case .city:
            cell.populateCellWithName(name: (self.optionsArray[indexPath.row] as! City).cityName!)
        case .country:
            cell.populateCellWithName(name: (self.optionsArray[indexPath.row] as! Country).countryName!)
        case .profession:
            cell.populateCellWithName(name: (self.optionsArray[indexPath.row] as! Profession).profession!)
        case .gender:
            cell.populateCellWithName(name: self.optionsArray[indexPath.row] as! String)
        case .age:
            cell.populateCellWithName(name: self.optionsArray[indexPath.row] as! String)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.generalPickerViewControllerDidSelect(object: self.optionsArray[indexPath.row], selectionType: self.selectionType, controller: self)
    }
}
