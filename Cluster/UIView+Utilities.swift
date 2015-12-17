//
//  UIView+Utilities.swift
//  Cluster
//
//  Created by Tejas Nikumbh on 12/16/15.
//  Copyright © 2015 Personal. All rights reserved.
//

import UIKit

extension UIView {
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
