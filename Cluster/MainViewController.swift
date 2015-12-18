//
//  MainViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/13/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var contactDetailFetcher: CSContactDetailFetcher?
    var filteredContacts = [CSContactDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Introduce a waitloader until requests are fetched. Ideally introduce a cache
        CSContactDetailFetcher.fetchContactDetailsWithCompletion {
            (contactDetailsFetcher: CSContactDetailFetcher) -> Void in
                self.contactDetailFetcher = contactDetailsFetcher
        }
        
        setupView()
        setupNavBar()
        setupSearchBar()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupView() {
        self.contactsTableView.backgroundColor = UIColor.themeColor()
        self.contactsTableView.separatorColor = UIColor.whiteColor()
        self.contactsTableView.contentInset = UIEdgeInsets(top: 5, left: 0,
            bottom: 0, right: 0)
        // Illogical but useful for hiding the gray stuff of search controller
        self.contactsTableView.backgroundView = UIView()
        // Useful for cancel button white color
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.classForCoder()]).tintColor = UIColor.whiteColor()
    }
    
    func setupNavBar() {
        // Styling up the bar properties
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Helvetica", size: 22)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        self.navigationController?.navigationBar.barTintColor = UIColor.themeColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Setting up and adding the items
        let title = "Cluster"
        let settingsBtn = getBarButtonItem(UIImage(named: "settings"), selector: Selector("settingsPressed:"))
        let addUserBtn = getBarButtonItem(UIImage(named: "add_user"), selector: Selector("addUserPressed:"))
        self.navigationItem.title = title
        self.navigationItem.leftBarButtonItems = [settingsBtn]
        self.navigationItem.rightBarButtonItems = [addUserBtn]
    }
    
    func setupSearchBar() {
        // Styling the bar
        searchController.searchBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        searchController.searchBar.barTintColor = UIColor.themeColor()
        // Important while resizing
        self.automaticallyAdjustsScrollViewInsets = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        // Finally setting our searchBar to be the header view
        self.contactsTableView.tableHeaderView = searchController.searchBar
    }

    func getBarButtonItem(image: UIImage?, selector: Selector?) -> UIBarButtonItem{
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
        navBarBtnView.addTarget(self, action: selector!, forControlEvents: .TouchUpInside)
        let navBarBtn = UIBarButtonItem()
        navBarBtn.customView = navBarBtnView
        
        return navBarBtn
    }
    
    // Selectors for Nav Bar Items
    func settingsPressed(settingsButton: UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : EditProfileViewController = storyboard.instantiateViewControllerWithIdentifier("editProfileViewController") as! EditProfileViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func addUserPressed(addUserButton: UIBarButtonItem) {
//        var inputTextField: UITextField?
//        let phoneNumberPrompt = UIAlertController(title: "Cluster", message: "Enter recipient's phone number", preferredStyle: UIAlertControllerStyle.Alert)
//        phoneNumberPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
//        phoneNumberPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//            if (CSUtils.validatePhoneNumber(inputTextField!.text)) {
//                // Send the contact a request and show success in completion
//            } else {
//                // Show a failure toast
//            }
//        }))
//        
//        phoneNumberPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
//            textField.placeholder = "Phone Number"
//            textField.keyboardType = UIKeyboardType.PhonePad
//            inputTextField = textField
//        })
        
        //presentViewController(phoneNumberPrompt, animated: true, completion: nil)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ConnectViewController = storyboard.instantiateViewControllerWithIdentifier("connectViewController") as! ConnectViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // UISearchResultUpdating protocol related methods
    func filterContentForSearchText(searchText: String?, scope: String = "All") {
        filteredContacts = (self.contactDetailFetcher?.userContactDetails.filter { userContactDetail in
            return userContactDetail.contactName.lowercaseString.containsString((searchText?.lowercaseString)!)
        })!
        self.contactsTableView.reloadData()
    }
}

// Extension implementing the UITableViewDatasource and UITableViewDelegate methods
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDatasource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.active && self.searchController.searchBar.text != "" {
            return filteredContacts.count
        }
        return (self.contactDetailFetcher?.userContactDetails.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("csCardCell") as! CSSummaryCard
        var cellModel: CSContactDetail?
        if searchController.active && searchController.searchBar.text != "" {
            cellModel = filteredContacts[indexPath.row]
        } else {
            cellModel = self.contactDetailFetcher?.userContactDetails[indexPath.row]
        }
        cell.contactDisplayPic.image = UIImage(named: (cellModel?.profilePicImageURL)!)
        cell.name.text = cellModel?.contactName
        cell.designation.text = cellModel?.contactDesignation
        cell.email.text = cellModel?.primaryEmail
        return cell
    }
    
    // UITableViewDelegate methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// Extension implementing the UISearchResultsUpdating Protocol
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
