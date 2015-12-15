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

    /* ====================================== Outlets ========================================= */
    @IBOutlet weak var rootScrollView: UIScrollView!
    
    @IBOutlet weak var detailCardProfilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    
    @IBOutlet weak var backBtnContainerView: UIView!
    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var editDetailsContainerView: UIView!
    
    @IBOutlet weak var primaryPhoneLabel: UILabel!
    @IBOutlet weak var secondaryPhoneLabel: UILabel!
    @IBOutlet weak var primaryEmailLabel: UILabel!
    @IBOutlet weak var secondaryEmailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    /* ================================= Super Methods Overridden ============================= */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setupView()
        setupGestureRecognizers()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    

    /* ================================= View Setup Methods =================================== */
    func setupView() {
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
    
    /* ================================= Gesture Recognizers ================================== */
    func setupGestureRecognizers() {
        var tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("backBtnPressed:"))
        self.backBtnContainerView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("editPhotoPressed:"))
        self.cameraContainerView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("editDetailsPressed:"))
        self.editDetailsContainerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Selectors
    func backBtnPressed(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editPhotoPressed(gestureRecognizer: UITapGestureRecognizer? = nil) {
        let choosePictureController = UIAlertController(title: "PLEASE CHOOSE A METHOD",
            message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera",
            style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) -> Void in
            self.presentViewControllerWithSourceType(UIImagePickerControllerSourceType.Camera)
            choosePictureController.dismissViewControllerAnimated(true, completion: nil)
        })
        let galleryAction = UIAlertAction(title: "Gallery",
            style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) -> Void in
            self.presentViewControllerWithSourceType(UIImagePickerControllerSourceType.PhotoLibrary)
            choosePictureController.dismissViewControllerAnimated(true, completion: nil)
        })
        choosePictureController.addAction(cameraAction)
        choosePictureController.addAction(galleryAction)
        self.presentViewController(choosePictureController, animated: true, completion: nil)
    }
    
    func editDetailsPressed(gestureRecognizer: UITapGestureRecognizer? = nil) {
        
    }
    
    // Selector Helpers
    func presentViewControllerWithSourceType(
        imagePickerSourceType: UIImagePickerControllerSourceType) {
            
        if(UIImagePickerController.isSourceTypeAvailable(imagePickerSourceType)) {
            let imagePickerView = UIImagePickerController()
            imagePickerView.allowsEditing = true
            imagePickerView.delegate = self
            imagePickerView.sourceType = imagePickerSourceType
            self.presentViewController(imagePickerView, animated: true, completion: nil)
        }
            
    }
    
}

// Extension for picking photo
extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingImage image: UIImage,
        editingInfo: [String : AnyObject]?) {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.detailCardProfilePic.image = image
            // Persist the image in local cache as well as store it to the backend
    }
}
