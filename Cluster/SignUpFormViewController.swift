//
//  SignUpViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/18/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class SignUpFormViewController: CSFormBaseViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backBtnContainer: UIView!
    @IBOutlet weak var backBtnImageView: UIImageView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func setupGestureRecognizers() {
        super.setupGestureRecognizers()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("backBtnTapped:"))
        self.backBtnContainer.addGestureRecognizer(tapGestureRecognizer)
    }
 
    func backBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
