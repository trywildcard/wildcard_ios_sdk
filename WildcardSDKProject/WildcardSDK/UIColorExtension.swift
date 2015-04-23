//
//  ColorFactory.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation

/// Wildcard default colors
public extension UIColor{
    
    public class func wildcardDarkBlue()->UIColor{
        return UIColor(red: 40/255, green: 47/255, blue: 60/255, alpha: 1.0)
    }
    
    public class func wildcardLightBlue()->UIColor{
        return UIColor(red: 76/255, green: 180/255, blue: 255/255, alpha: 1.0)
    }
    
    public class func wildcardMediumGray()->UIColor{
        return UIColor(red: 155/255, green: 163/255, blue: 178/255, alpha: 1.0)
    }
    
    public class func wildcardBackgroundGray()->UIColor{
        return UIColor(red: 213/255, green: 219/255, blue: 229/255, alpha: 1.0)
    }
    
    public class func wildcardMediaBodyColor()->UIColor{
        return UIColor(red: 98/255, green: 107/255, blue: 128/255, alpha: 1.0)
    }
    
    public class func twitterBlue()->UIColor{
        return UIColor(red: 50/255, green: 222/255, blue: 244/255, alpha: 1.0)
    }
}