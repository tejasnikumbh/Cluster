//
//  ConnectViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/17/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

typealias EmptyClosure = () -> ()

class ConnectViewController: UIViewController {

    @IBOutlet weak var backBtnContainer: UIView!
    @IBOutlet weak var requestsTableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var recipientPhoneNumberField: UITextField!
    
    var requestsDetailFetcher: CSConnectionDetailFetcher?
    // View lifecycle and view property methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let spinner = CSUtils.startSpinner(self.requestsTableView)
        CSConnectionDetailFetcher.fetchConnectionDetailsWithCompletion({
            (connectionDetailFetcher: CSConnectionDetailFetcher?) -> Void in
            CSUtils.stopSpinner(spinner)
            if(connectionDetailFetcher == nil) { // Error guard
                CSUtils.log("Some error occurred while fetching requests")
            }
            // Successfully fetched all requests
            self.requestsDetailFetcher = connectionDetailFetcher
            self.requestsTableView.reloadData()
        },
        isRequest: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
        setupGestureRecognizers()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // View config methods
    func setupView() {
        self.recipientPhoneNumberField.keyboardType = UIKeyboardType.NumberPad
        self.requestsTableView.contentInset = UIEdgeInsets(top: 12, left: 0,
            bottom: 0, right: 0)
        self.requestsTableView.allowsMultipleSelectionDuringEditing = false
    }
    
    func setupGestureRecognizers() {
        var tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("backBtnTapped:"))
        self.backBtnContainer.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("resignResponder:"))
        self.bgView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Selectors
    func backBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resignResponder(gestureRecognizer:UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendRequestTapped(sender: UIButton) {
        let phoneNumberString = self.recipientPhoneNumberField.text
        if (CSUtils.validatePhoneNumber(phoneNumberString)) {
            if(CSUtils.validateClusterRequest(phoneNumberString)) {
                let spinner = CSUtils.startSpinner(self.view)
                self.sendContactRequest(
                    CSUtils.extractPhoneNumber(phoneNumberString),
                    spinner: spinner)
            } else {
                let dialog = CSUtils.getDisplayDialog(
                    "Invalid Request",
                    message: "You cannot add yourself on Cluster")
                self.presentViewController(dialog, animated: true, completion: nil)
                return
            }
        } else {
            let dialog = CSUtils.getDisplayDialog(
                "Invalid Phonenumber",
                message: "Please enter a valid number")
            self.presentViewController(dialog, animated: true, completion: nil)
            return
        }
    }
    
}

// Extension for table view methods
extension ConnectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.requestsDetailFetcher != nil) {
            return (self.requestsDetailFetcher?.userConnectionDetails.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCardCell") as! CSRequestCard
        let cellModel = self.requestsDetailFetcher?.userConnectionDetails[indexPath.row]
        cell.requestProfileBtn.setBackgroundImage(
            cellModel?.profilePicImage,
            forState: .Normal)
        cell.requestNameLabel.text = cellModel?.contactName
        cell.requestPhoneLabel.text = cellModel?.primaryPhone
        return cell
    }
    
    func tableView(tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        return // iOS 8 requires this empty method stub
    }
    
    func tableView(tableView: UITableView,
        editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let yesRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default,
            title: " Yes ", handler:{
                action, indexpath in
                self.processRequestForIndexPath(indexPath, shouldReject: false)
        });
        yesRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851,
                                               blue: 0.3922, alpha: 1.0);
        let noRowAction = UITableViewRowAction(
            style: UITableViewRowActionStyle.Default,
            title: "  No ", handler:{
                action, indexpath in
                self.processRequestForIndexPath(indexPath, shouldReject: true)
        });
        return [noRowAction, yesRowAction];
    }
    
}

import Parse

// Extension for Parse methods
extension ConnectViewController {
    
    func processRequestForIndexPath(contactIndexPath: NSIndexPath,
        shouldReject: Bool) {
        let user = PFUser.currentUser()
        var contact: PFUser?
        let contactModel = self.requestsDetailFetcher?
            .userConnectionDetails[contactIndexPath.row]
        let completion =
        {
            self.requestsDetailFetcher?.userConnectionDetails
                .removeAtIndex(contactIndexPath.row)
            self.requestsTableView.deleteRowsAtIndexPaths([contactIndexPath],
                withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        // Username is unique, so we do the connections based on that
        let query = PFUser.query()
        query!.whereKey("username", equalTo: (contactModel?.username!)!)
        
        // Executing the query
        let spinner = CSUtils.startSpinner(self.view)
        query!.findObjectsInBackgroundWithBlock {
            [unowned self] // Since we don't want a retention cycle in case block hangs
            (contacts: [PFObject]?, error: NSError?) -> Void in
            if(error != nil || contacts!.count == 0)
            { //Error guard
                CSUtils.stopSpinner(spinner)
                let dialog = CSUtils.getDisplayDialog(
                    "User Not Available",
                    message: "The user is not available on Cluster")
                self.presentViewController(dialog, animated: true, completion: nil)
                completion()
                return
            }
            
            let acceptCompletionBlock = {
                let dialog = CSUtils.getDisplayDialog(
                    "User Added",
                    message: "\(contact?.objectForKey("full_name") as! String) has been added!")
                self.presentViewController(dialog, animated: true, completion: nil)
                CSUtils.log("Successfully saved user connection!")
                completion()
            }
            
            let rejectCompletionBlock = {
                let dialog = CSUtils.getDisplayDialog(
                    "Request Rejected",
                    message: "\(contact?.objectForKey("full_name") as! String)'s request has been removed")
                self.presentViewController(dialog, animated: true, completion: nil)
                CSUtils.log("Successfully deleted user connection!")
                completion()
            }
            
            contact = contacts![0] as? PFUser
            var currentCompletionBlock: EmptyClosure
            if(!shouldReject) { currentCompletionBlock = acceptCompletionBlock }
            else { currentCompletionBlock = rejectCompletionBlock }
            self.processUserConnection(user,
                    contact: contact,
                    completion: currentCompletionBlock,
                    spinner: spinner,
                    shouldDelete: shouldReject)
            
        } // End of query execution
    }
    
    func processUserConnection(user: PFUser?, contact: PFUser?,
        completion: EmptyClosure, spinner: UIActivityIndicatorView?,
        shouldDelete: Bool) {
        
        let query = self.getConnectionForUserAndContactQuery(user, contact: contact)
        query!.findObjectsInBackgroundWithBlock {
            (connections: [PFObject]?, error: NSError?) -> Void in
            // Error Guard
            if(connections?.count < 0 || error != nil) {
                // Request was not found or there was an error
                CSUtils.stopSpinner(spinner!)
                let dialog = CSUtils.getDisplayDialog(
                    message: "Oops! Somethign went wrong")
                self.presentViewController(dialog, animated: true,
                    completion: nil)
                return
            }
            
            if (!shouldDelete) { // Request accepted, save connection
                var connectionsModified = 0
                for connection in connections! {
                    connection.setObject(false, forKey: "request_pending")
                    connection.saveInBackgroundWithBlock({
                        (success: Bool?, error: NSError?) -> Void in
                        CSUtils.stopSpinner(spinner!)
                        if(!success! || (error != nil)) { //Error Guard
                            let dialog = CSUtils.getDisplayDialog(
                                message: "Oops! Something went wrong")
                            self.presentViewController(dialog, animated: true,
                                completion: nil)
                            return
                        }
                        // Connection saved successfully!
                        connectionsModified += 1
                        if(connectionsModified == 2) {
                            completion()
                        }
                    })
                }
            } else {
                var connectionsModified = 0
                for connection in connections! {
                    connection.deleteInBackgroundWithBlock({
                        (success: Bool?, error: NSError?) -> Void in
                        CSUtils.stopSpinner(spinner!)
                        if(!success! || (error != nil)) { //Error Guard
                            let dialog = CSUtils.getDisplayDialog(
                                message: "Oops! Something went wrong")
                            self.presentViewController(dialog, animated: true,
                                completion: nil)
                            return
                        }
                        connectionsModified += 1
                        if(connectionsModified == 2) {
                            completion()
                        }
                    })
                }
            } // End of save|delete connection block
        }// End of connection query
    } // End of function
    
    func sendContactRequest(phoneNumber: String?, spinner: UIActivityIndicatorView?) {
        let user = PFUser.currentUser()
        let query = self.getUserFromPhoneQuery(phoneNumber)
        query!.findObjectsInBackgroundWithBlock {
            [unowned self] // Since we don't want a retention cycle in case block hangs
            (contacts: [PFObject]?, error: NSError?) -> Void in
            if(error != nil || contacts!.count == 0)
            { //Error guard
                CSUtils.stopSpinner(spinner!)
                let dialog = CSUtils.getDisplayDialog(
                    "Deleted Profile",
                    message: "The user has deleted his profile")
                self.presentViewController(dialog, animated: true, completion: nil)
                return
            }
            
            let contact = contacts![0] as? PFUser
            let userConnection = PFObject(className: "Connection")
            userConnection.setObject(user!, forKey: "core_user")
            userConnection.setObject(contact!, forKey: "contact_user")
            userConnection.setObject(user!, forKey: "request_sender")
            userConnection.setObject(true, forKey: "request_pending")
            userConnection.saveInBackgroundWithBlock({
                (success, error) -> Void in
                if(!success || (error != nil)) { // Error guard
                    CSUtils.stopSpinner(spinner!)
                    let dialog = CSUtils.getDisplayDialog(
                        "Request not sent",
                        message: "Oops! Something went wrong")
                    self.presentViewController(dialog, animated: true, completion: nil)
                    return
                }
                
                let contactConnection = PFObject(className: "Connection")
                contactConnection.setObject(contact!, forKey: "core_user")
                contactConnection.setObject(user!, forKey: "contact_user")
                contactConnection.setObject(user!, forKey: "request_sender")
                contactConnection.setObject(true, forKey: "request_pending")
                contactConnection.saveInBackgroundWithBlock({
                    (success, error) -> Void in
                    CSUtils.stopSpinner(spinner!)
                    if(!success || (error != nil)) { // Error guard
                        CSUtils.stopSpinner(spinner!)
                        let dialog = CSUtils.getDisplayDialog(
                            "Request not sent",
                            message: "Oops! Something went wrong")
                        self.presentViewController(dialog, animated: true,
                            completion: nil)
                        return
                    }
                    
                    let dialog = CSUtils.getDisplayDialog(
                        "Request sent successfully",
                        message: "Your request was sent succesfully!")
                    self.presentViewController(dialog, animated: true,
                        completion: nil)
                    return
                    
                })
            })
        } // End of query execution
    }
    
    func getConnectionForUserAndContactQuery(user: PFUser?,
        contact: PFUser?) -> PFQuery? {
        let queryUser = PFQuery(className: "Connection")
        queryUser.whereKey("core_user", equalTo: user!)
        queryUser.whereKey("contact_user", equalTo: contact!)
        let queryContact = PFQuery(className: "Connection")
        queryContact.whereKey("core_user", equalTo: contact!)
        queryContact.whereKey("contact_user", equalTo: user!)
        let query = PFQuery.orQueryWithSubqueries(
            [queryUser, queryContact])
        return query
    }
    
    func getUserFromPhoneQuery(phoneNumber: String?) -> PFQuery? {
        let primaryQuery = PFQuery(className: "_User")
        primaryQuery.whereKey("primary_phone", equalTo: phoneNumber!)
        let secondaryQuery = PFQuery(className: "_User")
        secondaryQuery.whereKey("secondary_phone", equalTo: phoneNumber!)
        let query = PFQuery.orQueryWithSubqueries(
            [primaryQuery, secondaryQuery])
        return query
    }
    
}