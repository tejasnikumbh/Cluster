//
//  EditProfileDetailsViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/16/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class EditProfileDetailsViewController: UIViewController {
    
    var backgroundImage: UIImage?
    @IBOutlet weak var backgroundImageMask: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addTintedBlur()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
    
}
