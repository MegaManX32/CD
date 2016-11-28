//
//  SignupCountryViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class SignupCountryViewController: UIViewController, SignupChooseFromListViewControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var countryButtonView: ButtonView!
    @IBOutlet weak var cityButtonView: ButtonView!
    @IBOutlet weak var zipCodeButtonView: ButtonView!
    @IBOutlet weak var professionButtonView: ButtonView!
    @IBOutlet weak var languageButtonView: ButtonView!
    
    var country : Country?
    var city : City?
    var languages : [Language]?
    var profession : Profession?
    
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
    

    // MARK: - View Preparation
    
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
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupChooseFromListViewController") as! SignupChooseFromListViewController
            controller.selectionType = .city
            controller.country = self.country
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
        self.professionButtonView.title = NSLocalizedString("Profession", comment: "profession")
        self.professionButtonView.isWhite = true
        self.professionButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupChooseFromListViewController") as! SignupChooseFromListViewController
            controller.selectionType = .language
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
        self.languageButtonView.title = NSLocalizedString("Language", comment: "language")
        self.languageButtonView.isWhite = true
        self.languageButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupChooseFromListViewController") as! SignupChooseFromListViewController
            controller.selectionType = .profession
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - SignupChooseFromListViewControllerDelegate methods
    
    func signupChooseFromListViewControllerDidSelect(object: AnyObject, selectionType: SelectionType, controller: UIViewController) {
        print("\(object)" + "\(selectionType)")
    }
}
