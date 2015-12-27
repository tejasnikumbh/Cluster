//
//  CSUser.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/27/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class CSUser: NSObject {
    static var requestsDetailFetcher: CSConnectionDetailFetcher?
    static var contactDetailFetcher: CSConnectionDetailFetcher?
    static var filteredContacts = [CSContactDetail]()
    
    static func fetchUserData(stopLoader: EmptyClosure?,
        refreshControl: UIRefreshControl?, connectionsTableView: UITableView?,
        isRequest: Bool)
    {
        CSConnectionDetailFetcher.fetchConnectionDetailsWithCompletion({
            (connectionDetailsFetcher: CSConnectionDetailFetcher?) -> Void in
            if(stopLoader != nil){ stopLoader!() }
            refreshControl?.endRefreshing()
            if(connectionDetailsFetcher == nil)
            { // Error Guard
                CSUtils.log("Some error occured in fetching objects")
                return
            }
            // Successfully fetched the contacts
            if(!isRequest) { CSUser.contactDetailFetcher = connectionDetailsFetcher }
            else { CSUser.requestsDetailFetcher = connectionDetailsFetcher }
            connectionsTableView?.reloadData() },
            isRequest: isRequest) // since we are fetching contacts and not requests
    }
}
