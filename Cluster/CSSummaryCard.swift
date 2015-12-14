//
//  CSCardSummary.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/13/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class CSSummaryCard: UITableViewCell {

    @IBOutlet weak var contactDisplayPic: UIImageView!
    @IBOutlet weak var contactDisplayPicContainer: UIView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contactDisplayPic.layer.cornerRadius = 8
        self.contactDisplayPic.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
