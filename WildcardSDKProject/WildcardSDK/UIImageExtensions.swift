//
//  UIImageExtensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

extension UIImage{
    class func loadFrameworkImage(name:String)->UIImage?{
        let image = UIImage(named: name, inBundle: NSBundle.wildcardSDKBundle(), compatibleWithTraitCollection: nil)
        return image
    }
}