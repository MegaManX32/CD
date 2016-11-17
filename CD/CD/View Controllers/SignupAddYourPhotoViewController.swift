//
//  SignupAddYourPhotoViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class SignupAddYourPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func takePhoto(sender: UIButton) {
        let imagePickerControleller = UIImagePickerController()
        imagePickerControleller.sourceType = .photoLibrary
        imagePickerControleller.delegate = self
        self.present(imagePickerControleller, animated: true, completion: nil)
    }
    
    // MARK: - UINavigationControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        
        // present SignupYouLookGoodViewController
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupYouLookGoodViewController") as! SignupYouLookGoodViewController
        controller.avatarImage = image
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
