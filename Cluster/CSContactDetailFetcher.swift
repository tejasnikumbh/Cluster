//
//  ContactDetailFetcher.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/15/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit
import Parse

// Extensively uses Parse methods so no seperate extension
class CSContactDetailFetcher: NSObject {
    
    var userContactDetails: [CSContactDetail] = []
    
    init(userContactDetails: [CSContactDetail]) {
        self.userContactDetails = userContactDetails
    }
    
    class func fetchContactDetailsWithCompletion(completion:(CSContactDetailFetcher) -> Void) {
        // Defining the array of results
        var userContactDetailsArray: [CSContactDetail] = []
        
        let getAcceptedConnectionsQuery = PFQuery(className: "Connection")
        getAcceptedConnectionsQuery.whereKey("core_user", equalTo: PFUser.currentUser()!)
        getAcceptedConnectionsQuery.whereKey("request_pending", equalTo: false)
        
        getAcceptedConnectionsQuery.findObjectsInBackgroundWithBlock {
            (connections: [PFObject]?, error: NSError?) -> Void in
            if((error != nil) || connections?.count == 0) { //Error guard
            // Do completion jugaad to handle error
                CSUtils.log("Error loading connections")
                return
            }
            
            var acceptedContacts: [AnyObject] = []
            for connection in connections! {
                let currentUser = connection["contact_user"] as! PFUser
                acceptedContacts += [currentUser.objectId as! AnyObject]
            }
            
            let getUsersCorrespondingToConnnectionsQuery = PFUser.query()!
            getUsersCorrespondingToConnnectionsQuery.whereKey("objectId",
                containedIn: acceptedContacts)
            
            getUsersCorrespondingToConnnectionsQuery.findObjectsInBackgroundWithBlock {
                (contacts: [PFObject]?, error: NSError?) -> Void in
                if((error != nil) || contacts?.count == 0) { //Error guard
                    // Do completion jugaad to handle error
                    if (error != nil) { CSUtils.log("Error loading connections") }
                    else { CSUtils.log("No connections found for given query") }
                    return
                }
                
                for contact in contacts! {
                    let userImageFile: PFFile = contact.objectForKey("profile_pic")! as! PFFile
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData, error) -> Void in
                        if(error != nil) { //Error guard
                            CSUtils.log("Error fetching requests")
                        }
                        
                        let userImage = UIImage(data: imageData!)
                        let csContact = CSContactDetail(
                            username: contact.objectForKey("username")! as? String,
                            profilePicImage: userImage,
                            contactName: contact.objectForKey("full_name")! as? String,
                            contactDesignation: contact.objectForKey("designation")! as? String,
                            primaryPhone: contact.objectForKey("primary_phone")! as? String,
                            secondaryPhone: contact.objectForKey("secondary_phone")! as? String,
                            primaryEmail: contact.objectForKey("primary_email")! as? String,
                            secondaryEmail: contact.objectForKey("secondary_email")! as? String,
                            address: contact.objectForKey("address")! as? String)
                        
                        userContactDetailsArray.append(csContact)
                        
                        if(userContactDetailsArray.count == contacts!.count) {
                            let contactDetailFetcherResultObject = CSContactDetailFetcher(
                                userContactDetails: userContactDetailsArray)
                            completion(contactDetailFetcherResultObject)
                        }
                        
                    }
                }
                
            } // End of contacts query
        } // End of connections query
    } // End of function
    
}
