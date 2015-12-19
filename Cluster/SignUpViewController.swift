//
//  SignUpViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/18/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backBtnContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        setupView()
        setupGestureRecognizers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupView() {
        
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("backBtnTapped:"))
        self.backBtnContainer.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func backBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
