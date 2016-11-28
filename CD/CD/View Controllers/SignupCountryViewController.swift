//
//  SignupCountryViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignupCountryViewController: UIViewController, SignupChooseFromListViewControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var countryButtonView: ButtonView!
    @IBOutlet weak var cityButtonView: ButtonView!
    @IBOutlet weak var zipCodeButtonView: ButtonView!
    @IBOutlet weak var professionButtonView: ButtonView!
    @IBOutlet weak var languageButtonView: ButtonView!
    
    var userID : String!
    var country : Country?
    var city : City?
    var language : Language?
    var profession : Profession?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.userID = "41ac22d7-8f04-45e7-8290-334a9f32ce0c"
//        NetworkManager.sharedInstance.getUser(userID: self.userID, success: {
//            [unowned self] in
//            // do nothing
//        }) { (errorMesssage) in
//            print(errorMesssage)
//        }

        // prepare text fields
        self.prepareButtonViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareButtonViews() {
        self.countryButtonView.title = NSLocalizedString("Country", comment: "country")
        self.countryButtonView.isWhite = true
        self.countryButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupChooseFromListViewController") as! SignupChooseFromListViewController
            controller.selectionType = .country
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
        self.cityButtonView.title = NSLocalizedString("City", comment: "city")
        self.cityButtonView.isWhite = true
        self.cityButtonView.action = { [unowned self] in
            
            // first check if country
            guard let country = self.country else {
                CustomAlert.presentAlert(message: "You must choose country first", controller: self)
                return
            }
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupChooseFromListViewController") as! SignupChooseFromListViewController
            controller.selectionType = .city
            controller.country = country
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
        self.professionButtonView.title = NSLocalizedString("Profession", comment: "profession")
        self.professionButtonView.isWhite = true
        self.professionButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupChooseFromListViewController") as! SignupChooseFromListViewController
            controller.selectionType = .profession
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
        self.languageButtonView.title = NSLocalizedString("Language", comment: "language")
        self.languageButtonView.isWhite = true
        self.languageButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupChooseFromListViewController") as! SignupChooseFromListViewController
            controller.selectionType = .language
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - User actions
    
    @IBAction func nextAction(sender: UIButton) {
        guard let countryName = self.country?.countryName, let cityName = self.city?.cityName, let languageID = self.language?.uid, let professionName = self.profession?.profession else {
            CustomAlert.presentAlert(message: "Please select country, city, language and profession", controller: self)
            return;
        }
        
        // update user
        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            // get user and update
            let user = User.findUserWith(uid: self.userID, context: context)
            user?.country = countryName
            user?.city = cityName
            user?.proffesion = professionName
            
            // add language
            let language = Language.findLanguageWith(id: languageID, context: context)
            user?.addToLanguages(language!)
            
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
    
    func signupChooseFromListViewControllerDidSelect(object: AnyObject, selectionType: SelectionType, controller: UIViewController) {
        switch selectionType {
        case .country:
            self.country = object as? Country
            self.countryButtonView.title = self.country?.countryName
            self.city = nil
            self.cityButtonView.title = "City"
        case .city:
            self.city = object as? City
            self.cityButtonView.title = self.city?.cityName
        case .language:
            self.language = object as? Language
            self.languageButtonView.title = self.language?.language
        case .profession:
            self.profession = object as? Profession
            self.professionButtonView.title = self.profession?.profession
        }
        
        self.view.setNeedsDisplay()
    }
}
