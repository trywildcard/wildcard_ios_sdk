//
//  UIFontExtension.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

public extension UIFont{
   
    public class func wildcardStandardTitleFont()->UIFont{
        return UIFont(name: "Polaris-Bold", size: 20.0)!
    }
    
    public class func wildcardStandardDescriptionFont()->UIFont{
        return UIFont(name: "Polaris-Medium", size: 16.0)!
        
    }
}