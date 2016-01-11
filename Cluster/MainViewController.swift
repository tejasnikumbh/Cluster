//
//  MainViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/13/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController {

    @IBOutlet var rootView: UIView!
    @IBOutlet weak var contactsTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let refreshControl: UIRefreshControl? = UIRefreshControl()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
        self.setupNavBar()
        self.setupSearchBar()
        self.setupGestureRecognizers()
        self.setupRefreshControl()
        self.contactsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // REdirect to login screen if not already logged in
        if(PFUser.currentUser() == nil) { // Not logged in Guard
            let viewController: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginSignupFlowViewController")
                as! UINavigationController
            self.presentViewController(viewController, animated: true, completion: nil)
            return
        }
        // Ideally introduce a cache.
        let spinner = CSUtils.startSpinner(self.contactsTableView,
            hasBeenInitialized: false)
        self.fetchContactData(nil, stopLoader: {
            CSUtils.stopSpinner(spinner)
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupView() {
        self.contactsTableView.backgroundColor = UIColor.themeColor()
        self.contactsTableView.separatorColor = UIColor.whiteColor()
        self.contactsTableView.contentInset = UIEdgeInsets(top: 0, left: 0,
            bottom: 0, right: 0)
        // Illogical but useful for hiding the gray stuff of search controller
        self.contactsTableView.backgroundView = UIView()
        // Useful for cancel button white color
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.classForCoder()])
            .tintColor = UIColor.whiteColor()
    }
    
    func setupNavBar() {
        // Styling the bar frame
        let path = UIBezierPath(
            roundedRect:(self.navigationController?.navigationBar.bounds)!,
            byRoundingCorners:[.TopRight, .TopLeft],
            cornerRadii: CGSizeMake(8, 8))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
        self.navigationController?.navigationBar.layer.mask = maskLayer
        // Styling up the bar properties
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Helvetica", size: 22)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        self.navigationController?.navigationBar.barTintColor = UIColor.themeColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),
            forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Setting up and adding the items
        let title = "Cluster"
        let settingsBtn = getBarButtonItem(UIImage(named: "settings"),
            selector: Selector("settingsPressed:"))
        let addUserBtn = getBarButtonItem(UIImage(named: "add_user"),
            selector: Selector("addUserPressed:"))
        self.navigationItem.title = title
        self.navigationItem.leftBarButtonItems = [settingsBtn]
        self.navigationItem.rightBarButtonItems = [addUserBtn]
    }
    
    func setupSearchBar() {
        // Styling the bar
        searchController.searchBar.setBackgroundImage(UIImage(),
             forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        // Important while resizing
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        searchController.searchBar.delegate = self
        // Finally setting our searchBar to be the header view
        if(self.contactsTableView.tableHeaderView == nil) {
            // Resetting this when already set will cause it to disappear
            self.contactsTableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func setupGestureRecognizers() {
        let longPressGR = UILongPressGestureRecognizer(target: self,
            action: Selector("longPressOnContact:"))
        self.contactsTableView.addGestureRecognizer(longPressGR)
    }
    
    func setupRefreshControl() {
        self.refreshControl!.addTarget(self, action: "fetchContactData:stopLoader:",
            forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl!.tintColor = UIColor.paleWhite()
        self.contactsTableView.addSubview(refreshControl!)
    }

    func getBarButtonItem(image: UIImage?, selector: Selector?) -> UIBarButtonItem {
        // Case of a space button
        if(image == nil && selector == nil) {
            let space = UIBarButtonItem(barButtonSystemItem: .FixedSpace,
                                        target: nil, action: nil)
            space.width = 0
            return space
        }
        // Generic button with params
        let navBarBtnView = UIButton()
        navBarBtnView.setImage(image, forState: .Normal)
        navBarBtnView.frame = CGRectMake(0, 0, 30, 30)
        navBarBtnView.addTarget(self, action: selector!,
            forControlEvents: .TouchUpInside)
        let navBarBtn = UIBarButtonItem()
        navBarBtn.customView = navBarBtnView
        
        return navBarBtn
    }
    
    // Selectors for Nav Bar Items
    func settingsPressed(settingsButton: UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : EditProfileViewController = storyboard
            .instantiateViewControllerWithIdentifier("editProfileViewController")
            as! EditProfileViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func addUserPressed(addUserButton: UIBarButtonItem) {
        //presentViewController(phoneNumberPrompt, animated: true, completion: nil)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ConnectViewController = storyboard
            .instantiateViewControllerWithIdentifier("connectViewController")
            as! ConnectViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // UISearchResultUpdating protocol related methods
    func filterContentForSearchText(searchText: String?, scope: String = "All") {
        CSUser.filteredContacts = (CSUser.contactDetailFetcher?.userConnectionDetails.filter {
            userContactDetail in
            return userContactDetail.contactName.lowercaseString
                .containsString((searchText?.lowercaseString)!)
        })
        self.contactsTableView.reloadData()
    }
    
    // Handle Long Press
    func longPressOnContact(gestureRecognizer: UILongPressGestureRecognizer) {
        let indexPath = self.contactsTableView.indexPathForRowAtPoint(
            gestureRecognizer.locationInView(self.contactsTableView))
        if((indexPath) != nil) {
            var cellModel: CSContactDetail?
            if searchController.active && searchController.searchBar.text != "" {
                cellModel = CSUser.filteredContacts![indexPath!.row]
            } else {
                cellModel = CSUser.contactDetailFetcher?.userConnectionDetails[indexPath!.row]
            }
            
            let handler: AlertActionClosure = {
                action in
                if(action.style != UIAlertActionStyle.Cancel){
                    CSUtils.makeCall(cellModel?.primaryPhone)
                }
            }
            
            let contactName = (cellModel?.contactName)!
            let dialog = CSUtils.getActionDialog("Confirm Call",
                message: "Call \(contactName)?",
                handler: handler)
            self.presentViewController(dialog, animated: true, completion:nil)
        }
    }
    
    // Helper methods for class
    func fetchContactData(sender: AnyObject?, stopLoader: EmptyClosure?) {
        CSUser.fetchUserData(stopLoader, refreshControl: self.refreshControl,
            connectionsTableView: self.contactsTableView, isRequest: false)
    }
    
}

// Extension implementing the UITableViewDatasource and UITableViewDelegate methods
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDatasource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.active && self.searchController.searchBar.text != "" {
            return (CSUser.filteredContacts)!.count
        }
        if(CSUser.contactDetailFetcher != nil){
            return (CSUser.contactDetailFetcher?.userConnectionDetails.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("csCardCell") as! CSSummaryCard
        var cellModel: CSContactDetail?
        if searchController.active && searchController.searchBar.text != "" {
            cellModel = (CSUser.filteredContacts)![indexPath.row]
        } else {
            cellModel = CSUser.contactDetailFetcher?.userConnectionDetails[indexPath.row]
        }
        cell.contactDisplayPic.image = cellModel?.profilePicImage
        cell.name.text = cellModel?.contactName
        cell.designation.text = cellModel?.contactDesignation
        cell.email.text = cellModel?.primaryEmail
        return cell
    }
    
    // UITableViewDelegate methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let viewController: EditProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("editProfileViewController")
            as! EditProfileViewController
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        var cellModel: CSContactDetail?
        if searchController.active && searchController.searchBar.text != "" {
            cellModel = (CSUser.filteredContacts)![indexPath.row]
        } else {
            cellModel = CSUser.contactDetailFetcher?.userConnectionDetails[indexPath.row]
        }
        viewController.isContactCard = true
        viewController.contactUser = cellModel!
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
}

// Extension implementing the UISearchResultsUpdating Protocol
extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.contactsTableView.scrollEnabled = false
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.contactsTableView.scrollEnabled = true
        self.setupSearchBar()
    }
}
