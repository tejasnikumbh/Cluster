//
//  UIColor+ExtraColors.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/16/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

extension UIColor {
    
    public class func themeColor() -> UIColor {
        return UIColor(red: 33.0/255.0, green: 107.0/255.0,
            blue: 171.0/255.0, alpha: 1.0)
    }
    public class func paleWhite() -> UIColor {
        return UIColor.whiteColor()
            .colorWithAlphaComponent(0.35)
    }
    public class func paleBlueGreen() -> UIColor {
        return UIColor(red: 20/255.0, green: 55/255.0,
            blue: 115/255.0, alpha: 0.25)
    }
    
}
