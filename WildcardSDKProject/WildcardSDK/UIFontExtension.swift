//
//  UIFontExtension.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

extension UIFont{
    class func defaultCardTitleFont()->UIFont{
        return UIFont.boldSystemFontOfSize(16.0)
    }
    
    class func defaultCardKickerFont()->UIFont{
        return UIFont.systemFontOfSize(11.0)
    }
    
    class func defaultCardDescriptionFont()->UIFont{
        return UIFont.systemFontOfSize(12.0)
    }
    
    class func defaultCardActionButton()->UIFont{
        return UIFont.boldSystemFontOfSize(12.0)
    }
}