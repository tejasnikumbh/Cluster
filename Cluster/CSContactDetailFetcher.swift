//
//  ContactDetailFetcher.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/15/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class CSContactDetailFetcher: NSObject {
    
    let userContactDetails: [CSContactDetail]
    
    init(userContactDetails: [CSContactDetail]) {
        self.userContactDetails = userContactDetails
    }
    
    static func fetchContactDetailsWithCompletion(completion:(CSContactDetailFetcher) -> Void) {
        // make async call, fetch contact details and populate the property
        let user1 = CSContactDetail(profilePicImageURL: "face", contactName: "Tejas Nikumbh", contactDesignation: "Software Developer", primaryPhone: "+91 750 608 1238", secondaryPhone: "+91 997 073 5269", primaryEmail: "tejnikumbh@gmail.com", secondaryEmail: "tejasnikumbh@gmail.com", address: "221B, Baker Street, London , New England")
        let user2 = CSContactDetail(profilePicImageURL: "face2", contactName: "Shaan Chugh", contactDesignation: "Quantitative Analyst", primaryPhone: "+91 888 342 2213", secondaryPhone: "+91 932 422 4352", primaryEmail: "schugh@stanford.edu", secondaryEmail: "schugh@gmail.com", address: "Cuff Parade, Bandra East, Mumbai, India")
        let user3 = CSContactDetail(profilePicImageURL: "face", contactName: "Tejas Nikumbh", contactDesignation: "Software Developer", primaryPhone: "+91 750 608 1238", secondaryPhone: "+91 997 073 5269", primaryEmail: "tejnikumbh@gmail.com", secondaryEmail: "tejasnikumbh@gmail.com", address: "221B, Baker Street, London , New England")
        let user4 = CSContactDetail(profilePicImageURL: "face2", contactName: "Shaan Chugh", contactDesignation: "Quantitative Analyst", primaryPhone: "+91 888 342 2213", secondaryPhone: "+91 932 422 4352", primaryEmail: "schugh@stanford.edu", secondaryEmail: "schugh@gmail.com", address: "Cuff Parade, Bandra East, Mumbai, India")
        let user5 = CSContactDetail(profilePicImageURL: "face", contactName: "Tejas Nikumbh", contactDesignation: "Software Developer", primaryPhone: "+91 750 608 1238", secondaryPhone: "+91 997 073 5269", primaryEmail: "tejnikumbh@gmail.com", secondaryEmail: "tejasnikumbh@gmail.com", address: "221B, Baker Street, London , New England")
        let user6 = CSContactDetail(profilePicImageURL: "face2", contactName: "Shaan Chugh", contactDesignation: "Quantitative Analyst", primaryPhone: "+91 888 342 2213", secondaryPhone: "+91 932 422 4352", primaryEmail: "schugh@stanford.edu", secondaryEmail: "schugh@gmail.com", address: "Cuff Parade, Bandra East, Mumbai, India")
        
        
        let userContactDetailsArray = [user1, user2, user3, user4, user5, user6]
        
        let contactDetailFetcherResultObject = CSContactDetailFetcher(
                                                userContactDetails: userContactDetailsArray)
        completion(contactDetailFetcherResultObject)
    }
    
}
