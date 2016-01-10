//
//  EditProfileDetailsViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/16/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class EditProfileFormViewController: CSFormBaseViewController {

    /* =========================================== Outlets =============================================== */
    
    var backgroundImage: UIImage?
    
    @IBOutlet weak var backgroundImageMask: UIView!
    @IBOutlet weak var spinnerMask: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var closeBtnContainer: UIView!

    @IBOutlet weak var currentEventTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var designationTextField: UITextField!
    @IBOutlet weak var primaryPhoneTextField: UITextField!
    @IBOutlet weak var secondaryPhoneTextField: UITextField!
    @IBOutlet weak var primaryEmailTextField: UITextField!
    @IBOutlet weak var secondaryEmailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var saveChangesBtn: UIButton!
    @IBOutlet weak var saveChangesBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextFieldContainer: UIView!
    @IBOutlet weak var designationTextFieldContainer: UIView!
    @IBOutlet weak var primaryPhoneTextFieldContainer: UIView!
    @IBOutlet weak var secondaryPhoneTextFieldContainer: UIView!
    @IBOutlet weak var primaryEmailTextFieldContainer: UIView!
    @IBOutlet weak var secondaryEmailTextFieldContainer: UIView!
    @IBOutlet weak var addressTextFieldContainer: UIView!
    
    
    @IBAction func saveChangesBtnTapped(sender: UIButton) {
        self.saveUserDetails()
    }
    
    /* ======================================== UIViewController Methods ================================== */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /* ========================================== View Config Methods ===================================== */

    func setupView() {
        self.setupKeyboardTypes()
        self.addTintedBlur()
        self.loadUserDetails()
    }
    
    func setupKeyboardTypes() {
        self.primaryPhoneTextField.keyboardType = UIKeyboardType.NumberPad
        self.secondaryPhoneTextField.keyboardType = UIKeyboardType.NumberPad
    }
 
    func addTintedBlur() {
        // Setting the backgroundImage
        self.backgroundImageView.image = self.backgroundImage
        // Adjusting mask color if you want to
        self.backgroundImageMask.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.35)
        // Adding the Blur Effect
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        self.backgroundImageView.addSubview(blurView)
    }
    
    override func setupGestureRecognizers() {
        super.setupGestureRecognizers()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("closeBtnTapped:"))
        self.closeBtnContainer.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func startObservingKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification,
            object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillChangeFrame:"),
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification,
            object:nil)
    }
    
    override func stopObservingKeyboard() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    /* ============================================== Selectors ============================================ */
    func closeBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0,
                    keyboardSize.height + 56.0, 0.0);
                self.rootScrollView.contentInset = contentInset
            }
        }
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame: CGRect? = userInfo[UIKeyboardFrameEndUserInfoKey]?
                .CGRectValue {
                let duration:NSTimeInterval = (
                    userInfo[UIKeyboardAnimationDurationUserInfoKey]
                    as? NSNumber)?
                    .doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey]
                    as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue
                    ?? UIViewAnimationOptions
                    .CurveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(
                    rawValue: animationCurveRaw)
                // Setting the bottom constraint value. This is important
                if(keyboardFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height) {
                    self.saveChangesBottomConstraint?.constant = 0.0
                } else {
                    self.saveChangesBottomConstraint?.constant = (keyboardFrame?.size.height)!
                }
                // Performing the animation
                UIView.animateWithDuration(duration,
                    delay: NSTimeInterval(0),
                    options: animationCurve,
                    animations: { self.view.layoutIfNeeded() },
                    completion: nil)
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsetsZero;
        self.rootScrollView.contentInset = contentInset
    }
    
}

// Extension for Parse related methods

import Parse

extension EditProfileFormViewController {
    func saveUserDetails() {
        
        let user = PFUser.currentUser()
        
        let currentEvent = self.currentEventTextField.text
        let fullName = self.nameTextField.text
        let designation = self.designationTextField.text
        let primaryPhone = self.primaryPhoneTextField.text
        let secondaryPhone = self.secondaryPhoneTextField.text
        let primaryEmail = self.primaryEmailTextField.text
        let secondaryEmail = self.secondaryEmailTextField.text
        let address = self.addressTextField.text
        
        let areUserDetailsValid = CSUtils.validateUserDetails(
            fullName, designation: designation,
            primaryPhone: primaryPhone, secondaryPhone: secondaryPhone,
            primaryEmail: primaryEmail, secondaryEmail: secondaryEmail,
            address: address)
            
        if(areUserDetailsValid){ // Guard for valid details
            // Add the current location to the current_event data provided by user
            // E.g:- currentEvent! = currentEvent! + "London"
            user?.setObject(currentEvent!, forKey: "current_event")
            user?.setObject(fullName!, forKey: "full_name")
            user?.setObject(designation!, forKey: "designation")
            user?.setObject(primaryPhone!, forKey: "primary_phone")
            user?.setObject(secondaryPhone!, forKey: "secondary_phone")
            user?.setObject(primaryEmail!, forKey: "primary_email")
            user?.setObject(secondaryEmail!, forKey: "secondary_email")
            user?.setObject(address!, forKey: "address")
        } else {
            // Show form with asterisk
            return
        }
        
        let spinner = CSUtils.startSpinner(self.view)
        self.saveChangesBtn.enabled = false
        user?.saveInBackgroundWithBlock({
            (success, error) -> Void in
            
            if(success && (error == nil)) { // If no error
                PFUser.currentUser()?.fetchInBackgroundWithBlock({
                    (user, error) -> Void in
                    
                    CSUtils.stopSpinner(spinner)
                    if(error == nil){
                        self.saveChangesBtn.enabled = true
                        let dialog = CSUtils.getDisplayDialog(
                            message: "Successfully updated details!")
                        self.presentViewController(dialog,
                        animated: true, completion: nil)
                    } else {
                        let dialog = CSUtils.getDisplayDialog(
                            message: "Error saving details, please try again")
                        self.presentViewController(dialog,
                            animated: true, completion: nil)
                    }
                    
                })
                return
            }
            
            // If guard fails and error is encountered
            let dialog = CSUtils.getDisplayDialog(
                message: "Error saving details, please try again")
            self.presentViewController(dialog,
                animated: true, completion: nil)
            
        })
    }
    
    func loadUserDetails() {
        let user = PFUser.currentUser()
        
        if let currentEvent = user?.objectForKey("current_event") as? String {
            self.currentEventTextField.attributedText = NSAttributedString(
            string: currentEvent,
            attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        }
        
        if let fullName = user?.objectForKey("full_name") as? String {
            self.nameTextField.attributedText =  NSAttributedString(
            string: fullName,
            attributes:[NSForegroundColorAttributeName:UIColor.whiteColor()])
        }
        
        if let designation = user?.objectForKey("designation") as? String {
            self.designationTextField.attributedText = NSAttributedString(
            string: designation,
            attributes:[NSForegroundColorAttributeName:UIColor.whiteColor()])
        }

        if let primaryPhone =  (user?.objectForKey("primary_phone") as? String) {
            self.primaryPhoneTextField.attributedText = NSAttributedString(
            string:primaryPhone,
            attributes:[NSForegroundColorAttributeName:UIColor.whiteColor()])
        }

        if let secondaryPhone = (user?.objectForKey("secondary_phone") as? String) {
            self.secondaryPhoneTextField.attributedText = NSAttributedString(
            string: secondaryPhone,
            attributes:[NSForegroundColorAttributeName:UIColor.whiteColor()])
        }
        
        if let primaryEmail = (user?.objectForKey("primary_email") as? String) {
            self.primaryEmailTextField.attributedText = NSAttributedString(
            string: primaryEmail,
            attributes:[NSForegroundColorAttributeName:UIColor.whiteColor()])
        }

        if let secondaryEmail = (user?.objectForKey("secondary_email") as? String) {
            self.secondaryEmailTextField.attributedText = NSAttributedString(
            string: secondaryEmail,
            attributes:[NSForegroundColorAttributeName:UIColor.whiteColor()])
        }

        if let address = (user?.objectForKey("address") as? String) {
            self.addressTextField.attributedText = NSAttributedString(
            string: address,
            attributes:[NSForegroundColorAttributeName:UIColor.whiteColor()])
        }

    }
}