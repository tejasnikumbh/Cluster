//
//  CSGrayWhitePlaceholder.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/21/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

class CSGrayWhitePlaceholder: UITextField {
    override func awakeFromNib() {
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder!,
            attributes:[NSForegroundColorAttributeName:UIColor.paleWhite()])
    }
}
