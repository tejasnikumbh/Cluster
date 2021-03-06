//
//  EditProfileViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/14/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit
import MessageUI
import QuartzCore
import Parse

class EditProfileViewController: UIViewController {
    
    var isContactCard: Bool = false
    var contactUser: CSContactDetail?
    
    var primaryPhone: String?
    var secondaryPhone: String?
    var primaryEmail: String?
    var secondaryEmail: String?
    var address: String?
    
    /* ====================================== Outlets and Actions ============================== */
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var rootContentView: UIView!
    
    @IBOutlet weak var detailCardProfilePic: UIImageView!
    @IBOutlet weak var detailCardProfilePicCentered: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var backBtnImageView: UIImageView!
    
    @IBOutlet weak var backBtnContainerView: UIView!
    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var currentEventLabel: UILabel!
    
    @IBOutlet weak var callImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var houseImageView: UIImageView!
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var currentEventValueLabel: UILabel!
    
    @IBOutlet weak var editDetailsContainerView: UIView!
    @IBOutlet weak var logOutBtn: UIButton!
    
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
        super.viewWillAppear(animated)
        self.setupUserDetails()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    

    /* ================================= View Config Methods =================================== */
    func setupView() {
        self.rootView.clipsToBounds = true
        self.rootView.layer.cornerRadius = 8
        if(isContactCard) {
            self.modifyForContactCard()
        }
        self.addGradientToView(detailCardProfilePic)
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.origin = CGPointMake(0, 0)
        blurView.frame.size.width = UIScreen.mainScreen().bounds.width
        blurView.frame.size.height = 320
        self.detailCardProfilePic.addSubview(blurView)
        if(isContactCard) {
            self.rootScrollView.scrollEnabled = false
        }
    }

    func modifyForContactCard() {
        // Hiding edit related stuff
        self.cameraContainerView.hidden = true
        self.editDetailsContainerView.hidden = true
        self.logOutBtn.hidden = true
        // Button modification
        self.backBtnImageView.image = UIImage(named: "close")
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
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("callPressed:"))
        self.callImageView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("emailPressed:"))
        self.emailImageView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("addressDetailsPressed:"))
        self.houseImageView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("morePressed:"))
        self.moreImageView.addGestureRecognizer(tapGestureRecognizer)
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
    
    func callPressed(gestureRecognizer: UITapGestureRecognizer? = nil) {
        CSUtils.makeCall(self.primaryPhone)
    }
    
    func emailPressed(gestureRecognizer: UITapGestureRecognizer? = nil) {
        let emailTitle = ""
        let messageBody = ""
        let toRecipents:[String]? = [self.primaryEmail!]
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setToRecipients(toRecipents)
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mc, animated: true, completion: nil)
        } else {
            CSUtils.log("Error Sending Emails")
        }
    }
    
    func addressDetailsPressed(gestureRecognizer: UITapGestureRecognizer? = nil) {
        let alert = CSUtils.getDisplayDialog("Address of Contact",message: self.address)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func morePressed(gestureRecognizer: UITapGestureRecognizer? = nil) {
        CSUtils.log("More pressed!")
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
        let spinner = CSUtils.startSpinner(self.view)
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
                CSUser.username = nil
                CSUser.contactDetailFetcher = nil
                CSUser.requestsDetailFetcher = nil
                CSUser.filteredContacts = []
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginSignupFlowViewController")
                self.presentViewController(viewController, animated: true, completion: nil)
                print("User logged out successfully")
                return
            })
        }
    }
    
    func saveUserProfilePic(image: UIImage?) {
        // Convert to JPG with 50% quality
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        let imageName = ((PFUser.currentUser()?.objectForKey("username"))! as! String) + "_pic.jpg"
        let imageFile = PFFile(name: imageName, data: imageData!)
        
        // Start saving image in background
        var spinner = CSUtils.startSpinner(self.view)
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
                self.detailCardProfilePicCentered.image = image!
                
            }) // End of association
        }) // End of image save
    }
    
    func setupUserDetails() {
        var currentEvent: String?
        var fullName: String?
        var designation: String?
        var primaryPhone: String?
        var secondaryPhone: String?
        var primaryEmail: String?
        var secondaryEmail: String?
        var address: String?
        if(!self.isContactCard) {
            
            var user: PFUser?
            user = PFUser.currentUser()
            self.detailCardProfilePic.image = UIImage(named: "request_placeholder")
            self.detailCardProfilePicCentered.image = UIImage(named: "request_placeholder")
            if let profilePic = user!.valueForKey("profile_pic") as! PFFile? {
                //let spinner = CSUtils.startSpinner(self.detailCardProfilePic)
                profilePic.getDataInBackgroundWithBlock({
                    (data, error) -> Void in
                    //CSUtils.stopSpinner(spinner)
                    var profilePicImage: UIImage?
                    if (error != nil) { // Error guard in case of invalid image
                        // Placeholder image here instead of face
                        profilePicImage = UIImage(named: "face")
                        return
                    }
                    // Successful image data fetch
                    profilePicImage = UIImage(data:data!)
                    self.detailCardProfilePic.image = profilePicImage
                    self.detailCardProfilePicCentered.image = profilePicImage
                })
            }
            
            currentEvent = user?.objectForKey("current_event") as! String?
            if(currentEvent == "" || currentEvent == nil) { currentEvent = "Unspecified" }
            fullName = user?.objectForKey("full_name") as! String?
            designation = user?.objectForKey("designation") as! String?
            primaryPhone = user?.objectForKey("primary_phone") as! String?
            secondaryPhone = user?.objectForKey("secondary_phone") as! String?
            primaryEmail = user?.objectForKey("primary_email") as! String?
            secondaryEmail = user?.objectForKey("secondary_email") as! String?
            address = user?.objectForKey("address") as! String?
            
            self.currentEventLabel.text = "CURRENT EVENT"
            
        } else {
            
            // Guard against bad values
            if((self.contactUser == nil)) {
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            fullName = self.contactUser!.contactName
            designation = self.contactUser!.contactDesignation
            primaryPhone = self.contactUser!.primaryPhone
            secondaryPhone = self.contactUser!.secondaryPhone
            primaryEmail = self.contactUser!.primaryEmail
            secondaryEmail = self.contactUser!.secondaryEmail
            address = self.contactUser!.address
            currentEvent = self.contactUser!.connectionLocation
            
            self.currentEventLabel.text = "MEETING PLACE"
            self.detailCardProfilePicCentered.image = self.contactUser!.profilePicImage
        }
        
        self.nameLabel.text = fullName
        self.designationLabel.text = designation
        self.primaryPhone = primaryPhone
        self.secondaryPhone = secondaryPhone
        self.primaryEmail = primaryEmail
        self.secondaryEmail = secondaryEmail
        self.address = address
        self.currentEventValueLabel.text = currentEvent
    }
    
}


// Extension for picking photo
extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK:- UIIMagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingImage image: UIImage,
        editingInfo: [String : AnyObject]?) {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.saveUserProfilePic(image)
    }
    
    // MARK:- MailComposeViewControllerDelegate methods
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

