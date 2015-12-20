//
//  LoginViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/18/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var rootScrollView: UIScrollView!
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
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterObservers()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupView() {
        self.navigationController?.navigationBarHidden = true
        self.loginBtnTrailingConstraint.constant = -1*self.usernameContainerView.frame.size.width/2.0 - 8.0
        self.signUpBtnLeadingConstraint.constant = self.usernameContainerView.frame.size.width/2.0 + 8.0
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("resignKeyboard:"))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func registerObservers() {
        self.startObservingKeyboard()
    }
    
    func deregisterObservers() {
        self.stopObservingKeyboard()
    }
    
    private func startObservingKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification,
            object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification,
            object:nil)
    }
    
    private func stopObservingKeyboard() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0,
                    keyboardSize.height, 0.0);
                self.rootScrollView.contentInset = contentInset
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsetsZero;
        self.rootScrollView.contentInset = contentInset
    }
    
    func resignKeyboard(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }

}
