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
        return UIFont(name: "Polaris-Bold", size: 16.0)!
    }
    
    class func wildcardStandardSubHeaderFont()->UIFont{
        return UIFont(name: "Polaris-Medium", size: 12.0)!
    }
    
    class func wildcardStandardHeaderFontLineHeight()->CGFloat{
        return 19.0;
    }
    
    class func wildcardStandardSubHeaderFontLineHeight()->CGFloat{
        return 18.0;
    }
    
    class func wildcardLargePlaceholderFont()->UIFont{
        return UIFont(name: "Polaris-Light", size: 20.0)!
    }
    
    class func wildcardStandardMediaBodyFont()->UIFont{
        return UIFont(name: "Tiempos", size:14.0)!
    }
    
    class func wildcardStandardMediaBodyFontLineHeight()->CGFloat{
        return 18.0
    }
    
}