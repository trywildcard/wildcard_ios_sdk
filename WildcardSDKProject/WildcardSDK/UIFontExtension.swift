//
//  UIFontExtension.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

extension UIFont{
   
    class func wildcardStandardHeaderFont()->UIFont{
        return UIFont(name: "Polaris-Bold", size: 20.0)!
    }
    
    class func wildcardStandardSubHeaderFont()->UIFont{
        return UIFont(name: "Polaris-Medium", size: 15.0)!
    }
    
    class func wildcardStandardHeaderFontLineHeight()->CGFloat{
        return 26;
    }
    
    class func wildcardStandardSubHeaderFontLineHeight()->CGFloat{
        return 20;
    }
    
    class func wildcardLargePlaceholderFont()->UIFont{
        return UIFont(name: "Polaris-Light", size: 28.0)!
    }
    
}