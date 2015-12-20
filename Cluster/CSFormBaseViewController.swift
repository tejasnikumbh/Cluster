//
//  CSScrollViewBaseViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/20/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class CSFormBaseViewController: UIViewController {

    @IBOutlet weak var rootScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupGestureRecognizers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterObservers()
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
    
    func startObservingKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification,
            object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification,
            object:nil)
    }
    
    func stopObservingKeyboard() {
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
