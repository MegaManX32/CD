//
//  SignupCountryViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignupCountryViewController: UIViewController, GeneralPickerViewControllerDelegate, MutlipleLanguagePickerViewControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var countryButtonView: ButtonView!
    @IBOutlet weak var cityButtonView: ButtonView!
    @IBOutlet weak var zipCodeButtonView: ButtonView!
    @IBOutlet weak var languageButtonView: ButtonView!
    @IBOutlet weak var genderButtonView: ButtonView!
    @IBOutlet weak var birthDateButtonView: ButtonView!
    
    var userID : String!
    var country : Country?
    var city : City?
    var languages : [Language]?
    var gender : String?
    var birthDate : Date?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare text fields
        self.prepareButtonViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareButtonViews() {
        self.countryButtonView.title = NSLocalizedString("Country", comment: "country")
        self.countryButtonView.isWhite = true
        self.countryButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GeneralPickerViewController") as! GeneralPickerViewController
            controller.topTitle = self.countryButtonView.title
            controller.selectionType = .country
            controller.delegate = self
            self.show(controller, sender: self)
        }
        self.cityButtonView.title = NSLocalizedString("City", comment: "city")
        self.cityButtonView.isWhite = true
        self.cityButtonView.action = { [unowned self] in
            
            // first check if country
            guard let country = self.country else {
                CustomAlert.presentAlert(message: "You must choose country first", controller: self)
                return
            }
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GeneralPickerViewController") as! GeneralPickerViewController
            controller.topTitle = self.cityButtonView.title
            controller.selectionType = .city
            controller.country = country
            controller.delegate = self
            self.show(controller, sender: self)
        }
        self.languageButtonView.title = NSLocalizedString("Language", comment: "language")
        self.languageButtonView.isWhite = true
        self.languageButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MutlipleLanguagePickerViewController") as! MutlipleLanguagePickerViewController
            controller.delegate = self
            self.show(controller, sender: self)
        }
        self.genderButtonView.title = NSLocalizedString("Gender", comment: "gender")
        self.genderButtonView.isWhite = true
        self.genderButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GeneralPickerViewController") as! GeneralPickerViewController
            controller.topTitle =  self.genderButtonView.title
            controller.selectionType = .gender
            controller.delegate = self
            self.show(controller, sender: self)
        }
        self.birthDateButtonView.title = NSLocalizedString("Birth Date", comment: "")
        self.birthDateButtonView.isWhite = true
        self.birthDateButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            controller.datePickedAction = { [unowned self] (pickedDate) in
                self.birthDateButtonView.title = StandardDateFormatter.presentationStringFrom(date: pickedDate)
                self.birthDate = pickedDate
                _ = self.navigationController?.popViewController(animated: true)
            }
            controller.dateCancelledAction = { [unowned self] in
                _ = self.navigationController?.popViewController(animated: true)
            }
            self.show(controller, sender: self)
        }

    }
    
    // MARK: - User actions
    
    @IBAction func nextAction(sender: UIButton) {
        guard let countryName = self.country?.countryName, let cityName = self.city?.cityName, let languages = self.languages, let gender = self.gender, let birthDate = self.birthDate as NSDate? else {
            CustomAlert.presentAlert(message: "Please select country, city, language, gender and date of birth", controller: self)
            return;
        }
        
        // add progress hud
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // get language IDs
        var languageIDArray = [String]()
        for language in languages {
            languageIDArray.append(language.uid!)
        }
        
        // update user
        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            // get user and update
            let user = User.findUserWith(uid: self.userID, context: context)
            user?.country = countryName
            user?.city = cityName
            user?.gender = gender
            user?.birthDate = birthDate
            
            // add languages
            for languageID in languageIDArray {
                let language = Language.findLanguageWith(id: languageID, context: context)
                user?.addToLanguages(language!)
            }
            
            // update user
            NetworkManager.sharedInstance.createOrUpdate(user: user!, context: context, success: { [unowned self] (userID) in
                
                // go to interests
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupYourInterestsViewController") as! SignupYourInterestsViewController
                controller.userID = userID
                self.show(controller, sender: self)
                MBProgressHUD.hide(for: self.view, animated: true)
                }, failure: { [unowned self] (errorMessage) in
                    print(errorMessage)
                    MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
    
    // MARK: - SignupChooseFromListViewControllerDelegate methods
    
    func generalPickerViewControllerDidSelect(object: Any, selectionType: SelectionType, selectedIndex : Int, controller: UIViewController) {
        switch selectionType {
        case .country:
            self.country = object as? Country
            self.countryButtonView.title = self.country?.countryName
            self.city = nil
            self.cityButtonView.title = "City"
        case .city:
            self.city = object as? City
            self.cityButtonView.title = self.city?.cityName
        case .profession:
            break
        case .gender:
            self.gender = object as? String
            self.genderButtonView.title = self.gender
        default:
            break
            // do nothing, should never happen
        }
        
        // pop view controller
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func generalPickerViewControllerDidCancel(controller: UIViewController) {
        
        // pop view controller
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - MutlipleLanguagePickerViewControllerDelegate methods
    
    func mutlipleLanguagePickerViewControllerDidSelect(languages: [Language], controller: MutlipleLanguagePickerViewController) {
        self.languages = languages
        
        // upate languages label
        var languagesTitle = ""
        var index = 0
        if let languages = self.languages {
            for language in languages {
                languagesTitle += index == 0 ? language.language! : ", \(language.language!)"
                index += 1
            }
        }
        
        self.languageButtonView.title = languagesTitle
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func mutlipleLanguagePickerViewControllerDidCancel(controller: MutlipleLanguagePickerViewController) {
        
        // pop view controller
        _ = self.navigationController?.popViewController(animated: true)
    }
}
