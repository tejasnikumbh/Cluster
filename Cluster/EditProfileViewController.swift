//
//  EditProfileViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/14/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit
import QuartzCore

class EditProfileViewController: UIViewController {

    /* ============================== Outlets ============================== */
    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var detailCardProfilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var backBtnContainerView: UIView!
    
    
    
    /* ========================= Super Methods Overridden =================== */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setupView()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    

    /* ========================== View Setup Methods ======================== */
    func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("backBtnPressed:"))
        self.backBtnContainerView.addGestureRecognizer(tapGestureRecognizer)
        addGradientToView(detailCardProfilePic)
    }
    
    func addGradientToView(imageView: UIImageView!) {
        let colorTop = UIColor(white: 0.0, alpha: 0.0).CGColor
        let colorBottom = UIColor(white: 0.0, alpha: 0.75).CGColor
        let gradient: CAGradientLayer
        gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0.0, y: 0.0,
            width: self.view.frame.size.width,
            height: 320.0)
        gradient.colors = [ colorTop, colorBottom]
        gradient.locations = [ 0.75, 1.0]
        imageView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    /* ============================ Selectors ============================== */
    func backBtnPressed(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
