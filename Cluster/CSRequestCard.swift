//
//  CSRequestCard.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/17/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class CSRequestCard: UITableViewCell {

    @IBOutlet weak var requestProfileBtn: UIButton!
    @IBOutlet weak var requestNameLabel: UILabel!
    @IBOutlet weak var requestPhoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.requestProfileBtn.layer.cornerRadius = 24
        self.requestProfileBtn.clipsToBounds = true
    }

}
