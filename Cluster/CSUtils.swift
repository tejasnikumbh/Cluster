//
//  CSUtils.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/14/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class CSUtils: NSObject {
 
    /* ============================= UI Utils ================================== */
    static func showCameraActionSheet(){
        
    }
    
    static func startSpinner(backgroundView: UIView) -> UIActivityIndicatorView {
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(
            frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        spinner.center = backgroundView.center
        spinner.hidesWhenStopped = true
        backgroundView.addSubview(spinner)
        dispatch_async(dispatch_get_main_queue())
        {
            () -> Void in
            spinner.startAnimating()
        }
        return spinner
    }
    
    static func stopSpinner(spinner: UIActivityIndicatorView) {
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
    
    
    /* ============================= Validation Utils ========================== */
    static func validatePhoneNumber(phoneNumber: String?) -> Bool{
        if(phoneNumber == nil) {
            print("Internal Error: Text Input String is nil")
            return false
        } else {
            // Need to validate for empty string
            // Valid phone number with international code
            // and then only return true
            return true
        }
        
    }
}
