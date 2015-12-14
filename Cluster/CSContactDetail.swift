//
//  CSContactDetails.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/14/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import Foundation

class CSContactDetail: NSObject {
    // Primary Required Properties
    let profilePicImageURL: String!
    let contactName: String!
    let contactDesignation: String!
    // Secondary Optional Properties
    let primaryPhone: String?
    let secondaryPhone: String?
    let primaryEmail: String?
    let secondaryEmail: String?
    let address: String?
    
    init(profilePicImageURL: String!, contactName: String!, contactDesignation: String!,
        primaryPhone: String?, secondaryPhone: String?,
        primaryEmail: String?, secondaryEmail: String?,
        address: String?) {
        self.profilePicImageURL = profilePicImageURL
        self.contactName = contactName
        self.contactDesignation = contactDesignation
            
        self.primaryPhone = primaryPhone
        self.secondaryPhone = secondaryPhone
            
        self.primaryEmail = primaryEmail
        self.secondaryEmail = secondaryEmail
        
        self.address = address
    }
    
}
