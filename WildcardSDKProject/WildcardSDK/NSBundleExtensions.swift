//
//  NSBundleExtensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public extension NSBundle{
    public class func wildcardSDKBundle()->NSBundle{
        let bundle = NSBundle(identifier: "com.trywildcard.WildcardSDK")
        return bundle!
    }
}