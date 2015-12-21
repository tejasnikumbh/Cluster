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
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var closeBtnContainer: UIView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var designationTextField: UITextField!
    @IBOutlet weak var primaryPhoneTextField: UITextField!
    @IBOutlet weak var secondaryPhoneTextField: UITextField!
    @IBOutlet weak var primaryEmailTextField: UITextField!
    @IBOutlet weak var secondaryEmailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var saveChangesBtn: UIButton!
    @IBOutlet weak var saveChangesBottomConstraint: NSLayoutConstraint!
    
    /* ======================================== UIViewController Methods ================================== */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /* ========================================== View Config Methods ===================================== */

    func setupView() {
        self.addTintedBlur()
        self.addTextFieldEffects()
    }
 
    func addTintedBlur() {
        // Setting the backgroundImage
        self.backgroundImageView.image = backgroundImage
        // Adjusting mask color if you want to
        self.backgroundImageMask.alpha = 0.35
        // Adding the Blur Effect
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        self.backgroundImageView.addSubview(blurView)
    }
    
    func addTextFieldEffects() {
        self.nameTextField.attributedPlaceholder = NSAttributedString(string:"Name",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.designationTextField.attributedPlaceholder = NSAttributedString(string:"Designation",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.primaryPhoneTextField.attributedPlaceholder = NSAttributedString(string:"Primary Phone",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.secondaryPhoneTextField.attributedPlaceholder = NSAttributedString(string:"Secondary Phone",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.primaryEmailTextField.attributedPlaceholder = NSAttributedString(string:"Primary Email",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.secondaryEmailTextField.attributedPlaceholder = NSAttributedString(string:"Secondary Email",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.addressTextField.attributedPlaceholder = NSAttributedString(string:"Address",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    override func setupGestureRecognizers() {
        super.setupGestureRecognizers()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("closeBtnTapped:"))
        self.closeBtnContainer.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func startObservingKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillChangeFrame:"),
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
    }
    
    override func stopObservingKeyboard() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    /* ============================================== Selectors ============================================ */
    func closeBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame: CGRect? = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
                // Extracting animation relevant params
                let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?
                    .doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions
                    .CurveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
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
    
}
