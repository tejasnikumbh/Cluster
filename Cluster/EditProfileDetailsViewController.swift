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
    
    @IBOutlet weak var backgroundImageMask: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var closeBtnContainer: UIView!

    /* ================================= Super Methods Overridden ============================= */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /* ================================= View Config Methods =================================== */

    func setupView() {
        self.addTintedBlur()
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
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("closeBtnTapped:"))
        self.closeBtnContainer.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /* ===================================== Selectors ===================================== */
    func closeBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
