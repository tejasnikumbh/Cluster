//
//  LoginViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/18/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit
import Parse

class LoginFormViewController: CSFormBaseViewController {

    /* ====================================== Outlets and IBActions =============================== */
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var loginBtnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpBtnLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    @IBAction func loginBtnTapped(sender: UIButton) {
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        // Validate the email and password before calling logInUser
        self.logInUser(username!, password: password!)
    }
    
    /* ====================================== UIViewController Methods ============================== */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupView()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupView() {
        self.usernameTextField.keyboardType = UIKeyboardType.NumberPad
        self.navigationController?.navigationBarHidden = true
        self.loginBtnTrailingConstraint.constant = -1*self.usernameContainerView.frame.size.width/2.0 - 8.0
        self.signUpBtnLeadingConstraint.constant = self.usernameContainerView.frame.size.width/2.0 + 8.0
        self.bgView.backgroundColor = UIColor.themeColor()
        self.rootScrollView.backgroundColor = UIColor.themeColor()
        self.passwordTextField.secureTextEntry = true
    }
}

// Extension for parse relevant methods
extension LoginFormViewController {
    
    func logInUser(username: String, password: String) {
        let spinner = CSUtils.startSpinner(self.view)
        PFUser.logInWithUsernameInBackground(username,
            password: password,
            block: {
                (user, error) -> Void in
                if ((user) != nil) {
                    dispatch_async(dispatch_get_main_queue(),
                    { // Successful Login
                        () -> Void in
                        CSUser.username = username
                        CSUser.fetchUserData({ CSUtils.stopSpinner(spinner) },
                            refreshControl: nil,
                            connectionsTableView: nil,
                            isRequest: false,
                            completion:
                            {
                                self.dismissViewControllerAnimated(true, completion: nil)
                                print("User successfully logged in")
                            }
                        )
                    })
                } else { // Invalid Login
                    CSUtils.stopSpinner(spinner)
                    let alertDialog = CSUtils.getDisplayDialog(
                        message: "Invalid Email or Password")
                    self.presentViewController(alertDialog,
                        animated: true, completion: nil)
                    CSUtils.log("Trouble logging user into app")
                }
        })
    }
    
}
