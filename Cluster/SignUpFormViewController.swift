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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func submitBtnTapped(sender: UIButton) {
        let fullName = self.fullNameTextField.text
        let phoneNumber = self.phoneNumberTextField.text
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        // TODO: Validate all these (including if password matches confirm password)
        self.signUpUser(email, password: password,
            fullName: fullName, phoneNumber: phoneNumber)
    }

    /* ======================================== Super Methods Overridden ================================== */

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
}

// Extension for parse methods
extension SignUpFormViewController {
    
    func signUpUser(email: String?, password: String?,
        fullName:String?, phoneNumber: String?) {
        let newUser = PFUser()
        newUser.username = email
        newUser.password = password
        newUser.setObject(email!, forKey: "primary_email")
        newUser.setObject(phoneNumber!, forKey: "primary_phone")
        newUser.setObject(fullName!, forKey: "full_name")
        let spinner = CSUtils.startSpinner(self.view)
        newUser.signUpInBackgroundWithBlock(
        {
            (success, error) -> Void in
            CSUtils.stopSpinner(spinner)
            if(success && (error) == nil) {
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
