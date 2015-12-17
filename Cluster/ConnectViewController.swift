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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestureRecognizers()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupView() {
        self.requestsTableView.allowsMultipleSelectionDuringEditing = false
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("backBtnTapped:"))
        self.backBtnContainer.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func backBtnTapped(gestureRecognizer: UITapGestureRecognizer? = nil) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

extension ConnectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCardCell") as! CSRequestCard
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Yes", handler:{action, indexpath in
            print("MORE•ACTION");
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "No", handler:{action, indexpath in
            print("DELETE•ACTION");
        });
        return [deleteRowAction, moreRowAction];
    }
}
