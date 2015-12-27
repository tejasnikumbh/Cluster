//
//  CSConnectionDetailFetcher.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/27/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit
import Parse

class CSConnectionDetailFetcher: NSObject {
    
    var userConnectionDetails: [CSContactDetail] = []
    init(userConnectionDetails: [CSContactDetail]) {
        self.userConnectionDetails = userConnectionDetails
    }
    
    class func fetchConnectionDetailsWithCompletion(
        completion:(CSConnectionDetailFetcher?) -> Void,
        isRequest: Bool) {
        // Defining the array of results
        var userConnectionDetailsArray: [CSContactDetail] = []
        let getConnectionsQuery = PFQuery(className: "Connection")
        getConnectionsQuery.whereKey("core_user", equalTo: PFUser.currentUser()!)
        getConnectionsQuery.whereKey("request_pending", equalTo: isRequest)
        if(isRequest) { // Fetch requests only where sender is not current user
            getConnectionsQuery.whereKey("request_sender", notEqualTo: PFUser.currentUser()!)
        }
        getConnectionsQuery.findObjectsInBackgroundWithBlock {
            (connections: [PFObject]?, error: NSError?) -> Void in
            if((error != nil) || connections?.count == 0) { //Error guard
                // Do completion jugaad to handle error
                if(error != nil){ CSUtils.log("Error loading connections") }
                else { CSUtils.log("No connections for given query") }
                completion(nil)
                return
            }
            
            var filteredUsers: [AnyObject] = []
            for connection in connections! {
                let currentUser = connection["contact_user"] as! PFUser
                filteredUsers += [currentUser.objectId as! AnyObject]
            }
            
            let getUsersCorrespondingToConnnectionsQuery = PFUser.query()!
            getUsersCorrespondingToConnnectionsQuery.whereKey("objectId",
                containedIn: filteredUsers)
            
            getUsersCorrespondingToConnnectionsQuery.findObjectsInBackgroundWithBlock {
                (users: [PFObject]?, error: NSError?) -> Void in
                if((error != nil) || users?.count == 0) { //Error guard
                    // Do completion jugaad to handle error
                    if (error != nil) { CSUtils.log("Error loading connections") }
                    else { CSUtils.log("No connections found for given query") }
                    completion(nil)
                    return
                }
                
                for user in users! {
                    let userImageFile: PFFile = user.objectForKey("profile_pic")! as! PFFile
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData, error) -> Void in
                        if(error != nil) { //Error guard
                            CSUtils.log("Error fetching requests")
                            completion(nil)
                            return
                        }
                        
                        let userImage = UIImage(data: imageData!)
                        let csContact = CSContactDetail(
                            username: user.objectForKey("username")! as? String,
                            profilePicImage: userImage,
                            contactName: user.objectForKey("full_name")! as? String,
                            contactDesignation: user.objectForKey("designation")! as? String,
                            primaryPhone: user.objectForKey("primary_phone")! as? String,
                            secondaryPhone: user.objectForKey("secondary_phone")! as? String,
                            primaryEmail: user.objectForKey("primary_email")! as? String,
                            secondaryEmail: user.objectForKey("secondary_email")! as? String,
                            address: user.objectForKey("address")! as? String)
                        
                        userConnectionDetailsArray.append(csContact)
                        
                        if(userConnectionDetailsArray.count == users!.count) {
                            // Alphabetical sort
                            userConnectionDetailsArray.sortInPlace({
                                (contact1, contact2) -> Bool in
                                if(contact1.contactName == contact2.contactName) {
                                    return contact1.username < contact2.username
                                } else {
                                    return contact1.contactName < contact2.contactName
                                }
                            })
                            
                            let connectionDetailFetcherResultObject = CSConnectionDetailFetcher(
                                userConnectionDetails: userConnectionDetailsArray)
                            completion(connectionDetailFetcherResultObject)
                        }
                    }
                }
            } // End of contacts query
        } // End of connections query
    } // End of function

}
