//
//  CreateRiderListViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 10/10/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
fileprivate let itemsPerRow: CGFloat = 3
fileprivate let heightOfRow: CGFloat = 100

class CreateRiderListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GeneralPickerViewControllerDelegate, MutlipleLanguagePickerViewControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    @IBOutlet weak var genderViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var countryButtonView: ButtonView!
    @IBOutlet weak var cityButtonView: ButtonView!
    @IBOutlet weak var checkInButtonView: ButtonView!
    @IBOutlet weak var checkOutButtonView: ButtonView!
    @IBOutlet weak var genderButtonView: ButtonView!
    @IBOutlet weak var ageButtonView: ButtonView!
    @IBOutlet weak var languageButtonView: ButtonView!
    
    @IBOutlet weak var riderListTextView: UITextView!
    
    var userID : String!
    var country : Country?
    var city : City?
    var languages : [Language]?
    var gender : String?
    var age : String?
    var checkInDate : NSDate?
    var checkOutDate : NSDate?
    var interestsArray : [(interest : Interest, checked : Bool)] = [(Interest, Bool)]()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // update constraints
        let screenWidth = UIScreen.main.bounds.width
        self.genderViewWidthConstraint.constant = screenWidth / 3 - 12
        self.ageViewWidthConstraint.constant = screenWidth / 3 - 12
        self.languageViewWidthConstraint.constant = screenWidth / 3 - 12
        
        // prepare button views
        self.prepareButtonViews()
        
        // update text view
        self.riderListTextView.layer.masksToBounds = true
        self.riderListTextView.layer.cornerRadius = 4
        
        // fetch interests
        let interests = Interest.findAllInterests(context: CoreDataManager.sharedInstance.mainContext)
        if (interests.isEmpty) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            NetworkManager.sharedInstance.getAllInterests(
                success: { [unowned self] in
                    let context = CoreDataManager.sharedInstance.mainContext
                    let interests = Interest.findAllInterests(context: context)
                    for interest in interests {
                        self.interestsArray.append((interest, false))
                    }
                    self.collectionView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                },
                failure: { [unowned self] (errorMessage) in
                    print(errorMessage)
                    MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
        else {
            for interest in interests {
                self.interestsArray.append((interest, false))
            }
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareButtonViews() {
        self.countryButtonView.title = NSLocalizedString("Country", comment: "country")
        self.countryButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GeneralPickerViewController") as! GeneralPickerViewController
            controller.selectionType = .country
            controller.delegate = self
            self.show(controller, sender: self)
        }
        self.cityButtonView.title = NSLocalizedString("City", comment: "city")
        self.cityButtonView.action = { [unowned self] in
            
            // first check if country
            guard let country = self.country else {
                CustomAlert.presentAlert(message: "You must choose country first", controller: self)
                return
            }
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GeneralPickerViewController") as! GeneralPickerViewController
            controller.selectionType = .city
            controller.country = country
            controller.delegate = self
            self.show(controller, sender: self)
        }
        self.languageButtonView.title = NSLocalizedString("Language", comment: "language")
        self.languageButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MutlipleLanguagePickerViewController") as! MutlipleLanguagePickerViewController
            controller.delegate = self
            self.show(controller, sender: self)
        }
        self.genderButtonView.title = NSLocalizedString("Gender", comment: "language")
        self.genderButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GeneralPickerViewController") as! GeneralPickerViewController
            controller.selectionType = .gender
            controller.delegate = self
            self.show(controller, sender: self)
        }
        self.ageButtonView.title = NSLocalizedString("Age", comment: "language")
        self.ageButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GeneralPickerViewController") as! GeneralPickerViewController
            controller.selectionType = .age
            controller.delegate = self
            self.show(controller, sender: self)
        }
        self.checkInButtonView.title = NSLocalizedString("Check In", comment: "")
        self.checkInButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            controller.datePickedAction = { [unowned self] (pickedDate) in
                self.checkInButtonView.title = "\(pickedDate)"
                self.checkInDate = pickedDate as NSDate?
            }
            self.show(controller, sender: self)
        }
        self.checkOutButtonView.title = NSLocalizedString("Check Out", comment: "")
        self.checkOutButtonView.action = { [unowned self] in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            controller.datePickedAction = { [unowned self] (pickedDate) in
                self.checkOutButtonView.title = "\(pickedDate)"
                self.checkOutDate = pickedDate as NSDate?
            }
            self.show(controller, sender: self)
        }
    }
    
    // MARK: - User Actions
    
    @IBAction func nextAction(sender: UIButton) {
        
        guard let countryName = self.country?.countryName, let cityName = self.city?.cityName, let languages = self.languages, let checkInDate = self.checkInDate, let checkOutDate = self.checkOutDate, let gender = self.gender, let age = self.age  else {
            CustomAlert.presentAlert(message: "Please select country, city, gender, check in date, check out date and language", controller: self)
            return;
        }
        
        // present hud
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // get interests IDs
        var selectedInterestsIDArray = [String]()
        for interestOption in self.interestsArray {
            if interestOption.checked {
                selectedInterestsIDArray.append(interestOption.interest.uid!)
            }
        }
        
        // get language IDs
        var languageIDArray = [String]()
        for language in languages {
            languageIDArray.append(language.uid!)
        }

        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            // find user
            let newRiderList = RiderList(context: context)
            newRiderList.userUid = self.userID
            newRiderList.country = countryName
            newRiderList.city = cityName
            newRiderList.checkIn = checkInDate
            newRiderList.checkOut = checkOutDate
            newRiderList.gender = gender
            newRiderList.age = Int(age) as NSNumber?
            
            // update rider list with interests
            for interestID in selectedInterestsIDArray {
                newRiderList.addToInterests(Interest.findInterestWith(id: interestID, context: context)!)
            }
            
            // update rider list with languages
            for languageID in languageIDArray {
                newRiderList.addToLanguages(Language.findLanguageWith(id: languageID, context: context)!)
            }
            
            // create new rider list
            NetworkManager.sharedInstance.createOrUpdate(riderList: newRiderList, context: context, success: { [unowned self] (riderListID) in
                print("Ruder list : \(riderListID)")
                MBProgressHUD.hide(for: self.view, animated: true)
            }, failure: {[unowned self] (errorMessage) in
                print(errorMessage)
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
        
    }
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UICollectionViewDelegate methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.interestsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignupInterestsCollectionViewCell.cellIdentifier(), for: indexPath) as! SignupInterestsCollectionViewCell
        cell.populateCellWithInterest(name: self.interestsArray[indexPath.item].interest.name!,
                                      imageName: (self.interestsArray[indexPath.item].interest.name!).lowercased(),
                                      checked: self.interestsArray[indexPath.item].checked
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: heightOfRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.interestsArray[indexPath.item].checked = !self.interestsArray[indexPath.item].checked
        self.collectionView.reloadItems(at: [indexPath])
    }

    // MARK: - SignupChooseFromListViewControllerDelegate methods
    
    func generalPickerViewControllerDidSelect(object: Any, selectionType: SelectionType, controller: UIViewController) {
        switch selectionType {
        case .country:
            self.country = object as? Country
            self.countryButtonView.title = self.country?.countryName
            self.city = nil
            self.cityButtonView.title = "City"
        case .city:
            self.city = object as? City
            self.cityButtonView.title = self.city?.cityName
        case .gender:
            self.gender = object as? String
            self.genderButtonView.title = self.gender
        case .age:
            self.age = object as? String
            self.ageButtonView.title = self.age
        default:
            break
            // do nothing, should never happen
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - MutlipleLanguagePickerViewControllerDelegate methods
    
    func mutlipleLanguagePickerViewControllerDidSelect(languages: [Language], controller: MutlipleLanguagePickerViewController) {
        self.languages = languages
        _ = self.navigationController?.popViewController(animated: true)
    }
}
