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
