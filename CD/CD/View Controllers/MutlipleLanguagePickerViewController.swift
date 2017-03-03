//
//  MutlipleLanguagePickerViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 1/3/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol MutlipleLanguagePickerViewControllerDelegate {
    func mutlipleLanguagePickerViewControllerDidSelect(languages: [Language], controller: MutlipleLanguagePickerViewController)
    func mutlipleLanguagePickerViewControllerDidCancel(controller: MutlipleLanguagePickerViewController)
}

class MutlipleLanguagePickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    var delegate : MutlipleLanguagePickerViewControllerDelegate?
    var languageOptionArray : [(language : Language, checked : Bool)] = [(Language, Bool)]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare table view
        self.tableView.tableFooterView = UIView.init(frame: .zero)
        
        // fetch languages
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.getAllLanguages(
            success: { [unowned self] in
                let context = CoreDataManager.sharedInstance.mainContext
                let languages = Language.findAllLanguages(context: context)
                for language in languages {
                    self.languageOptionArray.append((language, false))
                }
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            },
            failure: { [unowned self] (errorMessage) in
                print(errorMessage)
                MBProgressHUD.hide(for: self.view, animated: true)
        })
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
        return self.languageOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:GeneralPickerTableViewCell.cellIdentifier(), for: indexPath) as! GeneralPickerTableViewCell
        cell.populateCellWithName(name: self.languageOptionArray[indexPath.row].language.language!)
        cell.accessoryType = self.languageOptionArray[indexPath.row].checked ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.languageOptionArray[indexPath.item].checked = !self.languageOptionArray[indexPath.item].checked
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - User Actions
    
    @IBAction func okAction(sender : UIButton) {
        var resultLanguageArray = [Language]()
        for languageOption in self.languageOptionArray {
            if languageOption.checked {
                resultLanguageArray.append(languageOption.language)
            }
        }
        self.delegate?.mutlipleLanguagePickerViewControllerDidSelect(languages: resultLanguageArray, controller: self)
    }
    
    @IBAction func backAction(sender : UIButton) {
        self.delegate?.mutlipleLanguagePickerViewControllerDidCancel(controller: self)
    }
}
