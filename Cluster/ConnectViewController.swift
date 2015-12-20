//
//  ConnectViewController.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/17/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {

    @IBOutlet weak var backBtnContainer: UIView!
    @IBOutlet weak var requestsTableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    
    var requestsDetailFetcher: CSRequestDetailFetcher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Introduce a wait loader until requests are fetched, Ideally do caching
        CSRequestDetailFetcher.fetchRequestDetailsWithCompletion {
            (requestsDetailFetcher: CSRequestDetailFetcher) -> Void in
            self.requestsDetailFetcher = requestsDetailFetcher
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
    
    func backBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resignResponder(gestureRecognizer:UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    
}

extension ConnectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.requestsDetailFetcher?.requestsContactDetails.count)!
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCardCell") as! CSRequestCard
        let cellModel = self.requestsDetailFetcher?.requestsContactDetails[indexPath.row]
        cell.requestProfileBtn.setBackgroundImage(
            UIImage(named: (cellModel?.profilePicImageURL)!),
            forState: .Normal)
        cell.requestNameLabel.text = cellModel?.contactName
        cell.requestPhoneLabel.text = cellModel?.primaryPhone
        return cell
    }
    
    func tableView(tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView,
        editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let yesRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default,
            title: " Yes ", handler:{
                action, indexpath in
                print("YES•ACTION");
        });
        yesRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851,
                                               blue: 0.3922, alpha: 1.0);
        let noRowAction = UITableViewRowAction(
            style: UITableViewRowActionStyle.Default,
            title: "  No ", handler:{
                action, indexpath in
                print("NO•ACTION");
        });
        return [noRowAction, yesRowAction];
    }
}
