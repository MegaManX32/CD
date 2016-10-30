//
//  SignupFourDigitCodeViewController.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/21/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class SignupFourDigitCodeViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var code1Label: UILabel!
    @IBOutlet weak var code2Label: UILabel!
    @IBOutlet weak var code3Label: UILabel!
    @IBOutlet weak var code4Label: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var noticeLabel: UILabel!
    
    var codeLabelsArray: [UILabel] = []
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare code text field invisible
        self.codeTextField.alpha = 0
        self.codeTextField.keyboardType = UIKeyboardType.numberPad
        self.codeTextField.delegate = self
        
        // prepare code labels
        self.codeLabelsArray = [code1Label, code2Label, code3Label, code4Label]
        
        // prepare notice label
        self.noticeLabel.text = String.localizedStringWithFormat(NSLocalizedString("We sent a code to %@. Enter the code in that message.", comment: "Enter code message"), "064112233")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.codeTextField?.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func updateLabelValuesBasedOnText(text: String) {
        for i in 0 ..< self.codeLabelsArray.count {
            if i + 1 > text.characters.count {
                self.codeLabelsArray[i].text = "#"
                self.codeLabelsArray[i].textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
            else {
                self.codeLabelsArray[i].text = String(text[text.index(text.startIndex, offsetBy: 0)])
                self.codeLabelsArray[i].textColor = UIColor.white
            }
        }
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text as NSString?
        let newText = oldText?.replacingCharacters(in: range, with: string)
        if (newText?.characters.count)! == 4 {
            self.performSegue(withIdentifier: "greatSegue", sender: self)
            return false;
        }
        
        // update labels
        self.updateLabelValuesBasedOnText(text: newText!)
        return true
    }
}
