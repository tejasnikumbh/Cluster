//
//  CSUtils.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/14/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

typealias AlertActionClosure = (UIAlertAction) -> ()

class CSUtils: NSObject {
 
    /* ============================= UI Utils ================================== */
        
    static func startSpinner(backgroundView: UIView) -> (UIActivityIndicatorView) {
        let spinnerContainer: UIView = UIView()
        spinnerContainer.frame = CGRectMake(0, 0, 80, 80)
        spinnerContainer.center = backgroundView.center
        spinnerContainer.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        spinnerContainer.clipsToBounds = true
        spinnerContainer.layer.cornerRadius = 10

        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(
            frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        spinner.center = CGPointMake(spinnerContainer.frame.size.width / 2,
            spinnerContainer.frame.size.height / 2);
        spinner.hidesWhenStopped = true
    
        spinnerContainer.addSubview(spinner)
        backgroundView.addSubview(spinnerContainer)
        
        dispatch_async(dispatch_get_main_queue())
        {
            () -> Void in
            spinner.startAnimating()
        }
        
        return spinner
    }
    
    static func stopSpinner(spinner: UIActivityIndicatorView) {
        spinner.superview?.removeFromSuperview()
        dispatch_async(dispatch_get_main_queue())
        {
            () -> Void in
            spinner.stopAnimating()
        }
    }
    
    static func getDisplayDialog(title: String? = "Cluster",
        message: String?) -> UIAlertController
    {
        let alertDialog = UIAlertController(
                title: title,
                message: message,
                preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil)
        alertDialog.addAction(okAction)
        return alertDialog
    }
    
    static func getActionDialog(title: String? = "Cluster",
        message: String?,
        handler: AlertActionClosure) -> UIAlertController
    {
        let alertDialog = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: handler
        )
        let cancelAction = UIAlertAction(
            title: "CANCEL",
            style:  UIAlertActionStyle.Cancel,
            handler: handler
        )
        alertDialog.addAction(okAction)
        alertDialog.addAction(cancelAction)
        return alertDialog
    }
    
    
    /* ============================= Validation Utils ========================== */
    
    static func validateUserDetails(name: String?, designation: String?,
        primaryPhone: String?, secondaryPhone: String?,
        primaryEmail: String?, secondaryEmail: String?,
        address: String?) -> Bool {
        return true
    }
    
    static func validateFullName(name: String?) -> Bool {
        return true
    }
    
    static func validateDesignation(designation: String?) -> Bool {
        return true
    }
    
    static func validatePhoneNumber(phoneNumber: String?) -> Bool{
       return true
    }
    
    static func validateEmail(email: String?) -> Bool {
        return true
    }
    
    static func validateAddress(address: String?) -> Bool {
        return true
    }
    
    
    /* =========================== Debug Utils ================================== */
    static func log(message: String?) {
        print(message)
    }
    
    /* =========================== Telephony Utils ============================== */
    static func makeCall(phoneNumber: String?) {
        let dialPhone = CSUtils.extractPhoneNumber(phoneNumber)
        if(!CSUtils.validatePhoneNumber(dialPhone)) {
            CSUtils.log("Invalid Phone Number")
        }
        let phone = "tel://\(dialPhone!)";
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url);
    }
    
    static func extractPhoneNumber(phoneNumber: String?) -> String?{
        let substringRange = Range<String.Index>(start: (phoneNumber?.startIndex.advancedBy(1))!, end: (phoneNumber?.endIndex)!)
        let phoneNumberString = phoneNumber?.substringWithRange(substringRange)
        let phoneNumberStringArr = phoneNumberString?.componentsSeparatedByString(" ")
        return phoneNumberStringArr?.joinWithSeparator("")
    }
}
