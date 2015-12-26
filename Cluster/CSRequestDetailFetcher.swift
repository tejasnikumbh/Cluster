//
//  CSRequestDetailFetcher.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/17/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit
import Parse

// Extensively has parse methods so no extension
class CSRequestDetailFetcher: NSObject {
    
    var requestsContactDetails: [CSContactDetail]
    
    init(requestsContactDetails: [CSContactDetail]) {
        self.requestsContactDetails = requestsContactDetails
    }
    
    class func fetchRequestDetailsWithCompletion(completion:(CSRequestDetailFetcher?) -> Void) {
        // Defining the array of results
        var requestsContactDetailsArray: [CSContactDetail] = []
        
        // Fetch all connections where core user is current user and requests are pending
        let getPendingConnectionsQuery = PFQuery(className: "Connection")
        getPendingConnectionsQuery.whereKey("core_user",
            equalTo: PFUser.currentUser()!)
        getPendingConnectionsQuery.whereKey("request_pending", equalTo: true)
        getPendingConnectionsQuery.whereKey("request_sender", notEqualTo: PFUser.currentUser()!)
        
        getPendingConnectionsQuery.findObjectsInBackgroundWithBlock {
            (connections: [PFObject]?, error: NSError?) -> Void in
            if((error != nil) || connections?.count == 0) { //Error guard
                // Do completion jugaad to handle error
                if (error != nil) { CSUtils.log("Error loading connections") }
                else { CSUtils.log("No connections found for given query") }
                completion(nil)
                return
            }
            
            var pendingContacts: [AnyObject] = []
            for connection in connections! {
                let currentUser = connection["contact_user"] as! PFUser
                pendingContacts += [currentUser.objectId as! AnyObject]
            }
            
            let getUsersCorrespondingToConnnectionsQuery = PFUser.query()!
            getUsersCorrespondingToConnnectionsQuery.whereKey("objectId",
                containedIn: pendingContacts)
            
            getUsersCorrespondingToConnnectionsQuery.findObjectsInBackgroundWithBlock {
                (contacts: [PFObject]?, error: NSError?) -> Void in
                if((error != nil) || contacts?.count == 0) { //Error guard
                    // Do completion jugaad to handle error
                    if (error != nil) { CSUtils.log("Error loading connections") }
                    else { CSUtils.log("No connections found for given query") }
                    completion(nil)
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
                        
                        requestsContactDetailsArray.append(csContact)
                        
                        if(requestsContactDetailsArray.count == contacts!.count) {
                            let requestsDetailFetcherResultObject = CSRequestDetailFetcher(
                                requestsContactDetails: requestsContactDetailsArray)
                            completion(requestsDetailFetcherResultObject)
                        }
                        
                    }
                }
            } // End of contacts query
        } // End of connections query
    } // End of function

} // End of class
