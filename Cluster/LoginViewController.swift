//
//  LoginViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/18/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpBtnLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupView() {
        self.navigationController?.navigationBarHidden = true
        self.loginBtnTrailingConstraint.constant = -1*self.usernameContainerView.frame.size.width/2.0 - 8.0
        self.signUpBtnLeadingConstraint.constant = self.usernameContainerView.frame.size.width/2.0 + 8.0
    }
    
}
