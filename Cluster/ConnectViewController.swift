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
    
    var requestsDetailFetcher: CSRequestDetailFetcher?
    // View lifecycle and view property methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let spinner = CSUtils.startSpinner(self.view)
        CSRequestDetailFetcher.fetchRequestDetailsWithCompletion {
            (requestsDetailFetcher: CSRequestDetailFetcher?) -> Void in
            CSUtils.stopSpinner(spinner)
            if(requestsDetailFetcher == nil) { // Error guard
                CSUtils.log("Some error occurred while fetching requests")
            }
            // Successfully fetched all requests
            self.requestsDetailFetcher = requestsDetailFetcher
            self.requestsTableView.reloadData()
        }
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
            let spinner = CSUtils.startSpinner(self.view)
            self.sendContactRequest(
                CSUtils.extractPhoneNumber(phoneNumberString),
                spinner: spinner)
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
            return (self.requestsDetailFetcher?.requestsContactDetails.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCardCell") as! CSRequestCard
        let cellModel = self.requestsDetailFetcher?.requestsContactDetails[indexPath.row]
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
                self.acceptRequestForIndexPath(indexPath)
        });
        yesRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851,
                                               blue: 0.3922, alpha: 1.0);
        let noRowAction = UITableViewRowAction(
            style: UITableViewRowActionStyle.Default,
            title: "  No ", handler:{
                action, indexpath in
                self.rejectRequestForIndexPath(indexPath)
        });
        return [noRowAction, yesRowAction];
    }
    
}

import Parse

// Extension for Parse methods
extension ConnectViewController {
    
    func acceptRequestForIndexPath(contactIndexPath: NSIndexPath) {
        let user = PFUser.currentUser()
        var contact: PFUser?
        let contactModel = self.requestsDetailFetcher?
            .requestsContactDetails[contactIndexPath.row]
        let completion =
        {
            self.requestsDetailFetcher?.requestsContactDetails
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
                    "Deleted Profile",
                    message: "The user has deleted his profile")
                self.presentViewController(dialog, animated: true, completion: nil)
                completion()
                return
            }
            
            contact = contacts![0] as? PFUser
            self.saveUserConnection(user,
                contact: contact,
                completion:
                {
                    let dialog = CSUtils.getDisplayDialog(
                        "User Added",
                        message: "\(contact?.objectForKey("full_name") as! String) has been added!")
                    self.presentViewController(dialog, animated: true, completion: nil)
                    CSUtils.log("Successfully saved user connection!")
                    completion()
                },
                spinner: spinner)
        } // End of query execution
    }
    
    func rejectRequestForIndexPath(contactIndexPath: NSIndexPath) {
        let user = PFUser.currentUser()
        var contact: PFUser?
        let contactModel = self.requestsDetailFetcher?
            .requestsContactDetails[contactIndexPath.row]
        let completion =
        {
            self.requestsDetailFetcher?.requestsContactDetails
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
                    "Deleted Profile",
                    message: "The user has deleted his profile")
                self.presentViewController(dialog, animated: true, completion: nil)
                completion()
                return
            }
            
            contact = contacts![0] as? PFUser
            self.deleteUserConnection(user,
                contact: contact,
                completion:
                {
                    let dialog = CSUtils.getDisplayDialog(
                        "Request Rejected",
                        message: "\(contact?.objectForKey("full_name") as! String)'s request has been removed")
                    self.presentViewController(dialog, animated: true, completion: nil)
                    CSUtils.log("Successfully deleted user connection!")
                    completion()
                },
                spinner: spinner)
        }
    }
    
    func saveUserConnection(user: PFUser?, contact: PFUser?,
        completion: EmptyClosure, spinner: UIActivityIndicatorView?) {
        let queryUser = PFQuery(className: "Connection")
        queryUser.whereKey("core_user", equalTo: user!)
        queryUser.whereKey("contact_user", equalTo: contact!)
        
        let queryContact = PFQuery(className: "Connection")
        queryContact.whereKey("core_user", equalTo: contact!)
        queryContact.whereKey("contact_user", equalTo: user!)
            
        let query = PFQuery.orQueryWithSubqueries([queryUser, queryContact])
        query.findObjectsInBackgroundWithBlock {
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
        }// End of connection query
    }
    
    func deleteUserConnection(user: PFUser?, contact: PFUser?,
        completion: EmptyClosure, spinner: UIActivityIndicatorView?) {
            let queryUser = PFQuery(className: "Connection")
            queryUser.whereKey("core_user", equalTo: user!)
            queryUser.whereKey("contact_user", equalTo: contact!)
            
            let queryContact = PFQuery(className: "Connection")
            queryContact.whereKey("core_user", equalTo: contact!)
            queryContact.whereKey("contact_user", equalTo: user!)
            
            let query = PFQuery.orQueryWithSubqueries([queryUser, queryContact])
            query.findObjectsInBackgroundWithBlock {
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
            } // End of connection query
    }
    
    func sendContactRequest(phoneNumber: String?, spinner: UIActivityIndicatorView?) {
        let user = PFUser.currentUser()
        let query = PFQuery(className: "_User")
        query.whereKey("primary_phone", equalTo: phoneNumber!)
        query.findObjectsInBackgroundWithBlock {
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
                        self.presentViewController(dialog, animated: true, completion: nil)
                        return
                    }
                    
                    let dialog = CSUtils.getDisplayDialog(
                        "Request sent successfully",
                        message: "Your request was sent succesfully!")
                    self.presentViewController(dialog, animated: true, completion: nil)
                    return
                    
                })
            })
        } // End of query execution
    }
    
}