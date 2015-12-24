//
//  EditProfileViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/14/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit
import QuartzCore
import Parse

class EditProfileViewController: UIViewController {

    /* ====================================== Outlets and Actions ============================== */
    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var rootContentView: UIView!
    @IBOutlet weak var spinnerView: UIView!
    
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
    
    @IBAction func logOutTapped(sender: UIButton) {
        self.logOutUser()
    }
    
    /* ================================= Super Methods Overridden ============================= */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        PFUser.currentUser()?.refreshInBackgroundWithBlock({
            (user, error) -> Void in
            self.setupUserDetails()
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    

    /* ================================= View Config Methods =================================== */
    func setupView() {
        self.addGradientToView(detailCardProfilePic)
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
    
    /* ======================================= Selectors ====================================== */
    
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
        let cancelAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel, handler: nil)
        
        choosePictureController.addAction(cameraAction)
        choosePictureController.addAction(galleryAction)
        choosePictureController.addAction(cancelAction)
        
        self.presentViewController(choosePictureController, animated: true, completion: nil)
    }
    
    func editDetailsPressed(gestureRecognizer: UITapGestureRecognizer? = nil) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : EditProfileFormViewController = storyboard
            .instantiateViewControllerWithIdentifier("editProfileFormViewController")
            as! EditProfileFormViewController
        vc.backgroundImage = self.view.pb_takeSnapshot()
        self.presentViewController(vc, animated: true, completion: nil)

    }
    
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

// Extension for Parse Methods
extension EditProfileViewController {
  
    func logOutUser() {
        let spinner = CSUtils.startSpinner(self.spinnerView)
        PFUser.logOutInBackgroundWithBlock {
            (error) -> Void in
            CSUtils.stopSpinner(spinner)
            if((error) != nil) { // If error logging out, display it
                let alertDialog = CSUtils.getDisplayDialog(message: "Error logging out")
                self.presentViewController(alertDialog, animated:true, completion:nil)
                print("User not logged out successfully")
                return
            }
            // Navigate to login controller otherwise
            dispatch_async(dispatch_get_main_queue(),
            { // We need dispatch async since what if user has navigated away?
                () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginSignupFlowViewController")
                self.presentViewController(viewController, animated: true, completion: nil)
                print("User logged out successfully")
            })
        }
    }
    
    func saveUserProfilePic(image: UIImage?) {
        // Convert to JPG with 50% quality
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        let imageName = ((PFUser.currentUser()?.objectForKey("username"))! as! String) + "_pic.jpg"
        let imageFile = PFFile(name: imageName, data: imageData!)
        
        // Start saving image in background
        var spinner = CSUtils.startSpinner(self.detailCardProfilePic)
        imageFile?.saveInBackgroundWithBlock({
            (success, error) -> Void in
            
            CSUtils.stopSpinner(spinner)
            if((error != nil)) { // Error guard for saving image
                CSUtils.log("Error: \(error) \(error?.userInfo)")
                return
            }
            
            // Associate image with user on successful save
            let user = PFUser.currentUser()
            user?.setObject(imageFile!, forKey: "profile_pic")
            
            spinner = CSUtils.startSpinner(self.detailCardProfilePic)
            user?.saveInBackgroundWithBlock({
                (success, error) -> Void in
                
                CSUtils.stopSpinner(spinner)
                if(error != nil) { // Error guard for successful associated
                    CSUtils.log("Error saving object")
                    let dialog = CSUtils.getDisplayDialog(message: "There was an error uploading the image. Please try again")
                    self.presentViewController(dialog,animated: true, completion: nil)
                }
                
                // Succesfully saved and associated image
                self.detailCardProfilePic.image = image!
                
            }) // End of association
        }) // End of image save
    }
    
    func setupUserDetails() {
        let user = PFUser.currentUser()
        if let profilePic = user!.valueForKey("profile_pic") as! PFFile? {
            
            let spinner = CSUtils.startSpinner(self.detailCardProfilePic)
            profilePic.getDataInBackgroundWithBlock({
                (data, error) -> Void in
                
                CSUtils.stopSpinner(spinner)
                var profilePicImage: UIImage?
                if (error != nil) { // Error guard in case of invalid image
                    // Placeholder image here instead of face
                    profilePicImage = UIImage(named: "face")
                    return
                }
                
                // Successful image data fetch
                profilePicImage = UIImage(data:data!)
                self.detailCardProfilePic.image = profilePicImage
            })
            
        }
        let fullName = user?.objectForKey("full_name") as! String?
        let designation = user?.objectForKey("designation") as! String?
        let primaryPhone = user?.objectForKey("primary_phone") as! String?
        let secondaryPhone = user?.objectForKey("secondary_phone") as! String?
        let primaryEmail = user?.objectForKey("primary_email") as! String?
        let secondaryEmail = user?.objectForKey("secondary_email") as! String?
        let address = user?.objectForKey("address") as! String?
        
        self.nameLabel.text = fullName
        self.designationLabel.text = designation
        self.primaryPhoneLabel.text = primaryPhone
        self.secondaryPhoneLabel.text = secondaryPhone
        self.primaryEmailLabel.text = primaryEmail
        self.secondaryEmailLabel.text = secondaryEmail
        self.addressLabel.text = address
    }
    
}

// Extension for picking photo
extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingImage image: UIImage,
        editingInfo: [String : AnyObject]?) {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.saveUserProfilePic(image)
    }
}
