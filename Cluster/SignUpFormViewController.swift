//
//  SignUpViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/18/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit
import Parse

class SignUpFormViewController: CSFormBaseViewController {

    /* ======================================== Outlets and IBActions ===================================== */

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backBtnContainer: UIView!
    @IBOutlet weak var backBtnImageView: UIImageView!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var designationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func submitBtnTapped(sender: UIButton) {
        let fullName = self.fullNameTextField.text
        let designation = self.designationTextField.text
        let phoneNumber = self.phoneNumberTextField.text
        let password = self.passwordTextField.text
        // TODO: Validate all these (including if password matches confirm password)
        self.signUpUser(phoneNumber, fullName: fullName, designation: designation,
            phoneNumber: phoneNumber, password: password)
    }

    /* ======================================== Super Methods Overridden ================================== */

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupViews()
        self.setupGestureRecognizers()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func setupGestureRecognizers() {
        super.setupGestureRecognizers()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("backBtnTapped:"))
        self.backBtnContainer.addGestureRecognizer(tapGestureRecognizer)
    }
 
    /* ================================================ Selectors ========================================= */
    
    func backBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setupViews() {
        self.phoneNumberTextField.keyboardType = UIKeyboardType.NumberPad
        self.bgView.backgroundColor = UIColor.themeColor()
        self.rootScrollView.backgroundColor = UIColor.themeColor()
        self.passwordTextField.secureTextEntry = true
    }
    
}

// Extension for parse methods
extension SignUpFormViewController {
    
    func signUpUser(username: String?, fullName: String?,
        designation:String?, phoneNumber: String?, password: String?) {
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.setObject(fullName!, forKey: "full_name")
        newUser.setObject(designation!, forKey: "designation")
        newUser.setObject(phoneNumber!, forKey: "primary_phone")
        let spinner = CSUtils.startSpinner(self.view)
        newUser.signUpInBackgroundWithBlock(
        {
            (success, error) -> Void in
            CSUtils.stopSpinner(spinner)
            if(success && (error) == nil) {
                CSUser.username = username
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : UIViewController = storyboard
                    .instantiateViewControllerWithIdentifier("mainFlowViewController")
                self.presentViewController(vc, animated: true, completion: nil)
                CSUtils.log("Successfully saved user object to parse")
                return
            }
            // Display errors by creating a method in CSUtils
            let dialog = CSUtils.getDisplayDialog(message: "Error signing up!")
            self.presentViewController(dialog, animated: true, completion: nil)
            CSUtils.log("Error saving user object to backend")
        })
    }
    
}
