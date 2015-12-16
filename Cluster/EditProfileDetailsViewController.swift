//
//  EditProfileDetailsViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/16/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class EditProfileDetailsViewController: UIViewController {

    /* ====================================== Outlets ========================================= */
    
    var backgroundImage: UIImage?
    
    @IBOutlet weak var rootScrollView: UIScrollView!
    
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
    
    /* ================================= Super Methods Overridden ============================= */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterObservers()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /* ================================= View Config Methods =================================== */

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
    
    func setupGestureRecognizers() {
        var tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("closeBtnTapped:"))
        self.closeBtnContainer.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("resignKeyboard:"))
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
            selector: Selector("keyboardWillChangeFrame:"),
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification,
            object:nil)
    }
    
    private func stopObservingKeyboard() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /* ===================================== Selectors ===================================== */
    func closeBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0,
                    keyboardSize.height + self.saveChangesBtn.frame.height, 0.0);
                self.rootScrollView.contentInset = contentInset
            }
        }
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame: CGRect? = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
                // Extracting animation relevant params
                let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
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
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsetsZero;
        self.rootScrollView.contentInset = contentInset
    }
    
    func resignKeyboard(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
}
