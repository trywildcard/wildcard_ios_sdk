//
//  WildcardSDK.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/22/15.
//
//

import Foundation

//
//  ImageCache.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import Foundation
import NotificationCenter


/// Global properties to customize Card look and feel
@objc
public class WildcardSDK {
    
    // MARK: Private
    var __cardHorizontalScreenMargin:CGFloat = 15
    var __cardTitleFont:UIFont!
    var __cardKickerFont:UIFont!
    var __cardDescriptionFont:UIFont!
    var __cardActionButtonFont:UIFont!

    // swift doesn't support class constant variables yet, but you can do it in a struct
    class var sharedInstance : WildcardSDK{
        struct Static{
            static var onceToken : dispatch_once_t = 0
            static var instance : WildcardSDK? = nil
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = WildcardSDK()
            Static.instance!.__cardTitleFont = UIFont.boldSystemFontOfSize(16.0)
            Static.instance!.__cardKickerFont = UIFont.systemFontOfSize(11.0)
            Static.instance!.__cardDescriptionFont = UIFont.systemFontOfSize(12.0)
            Static.instance!.__cardActionButtonFont = UIFont.boldSystemFontOfSize(12.0)
        })
        return Static.instance!
    }
    
    /**
    Card widths are calculated relative to the screen width and is set at 15 points by default.
    
    Assuming Card Views are placed in the middle of a particular view, this is the margin to the horizontal edges. You may use this convenience method to set a custom screen margin.
    
    For full size customization, you must implement your own card visual source.
    */
    public class var cardHorizontalScreenMargin:CGFloat{
        get{
            return WildcardSDK.sharedInstance.__cardHorizontalScreenMargin
        }set{
            WildcardSDK.sharedInstance.__cardHorizontalScreenMargin = newValue
        }
    }
    
    /// Custom font for Card titles
    public class var cardTitleFont:UIFont{
        get{
            return WildcardSDK.sharedInstance.__cardTitleFont
        }set{
            WildcardSDK.sharedInstance.__cardTitleFont = newValue
        }
    }
    
    /// Custom font for Card kickers
    public class var cardKickerFont:UIFont{
        get{
            return WildcardSDK.sharedInstance.__cardKickerFont
        }set{
            WildcardSDK.sharedInstance.__cardKickerFont = newValue
        }
    }
    
    /// Custom font for Card descriptions
    public class var cardDescriptionFont:UIFont{
        get{
            return WildcardSDK.sharedInstance.__cardDescriptionFont
        }set{
            WildcardSDK.sharedInstance.__cardDescriptionFont = newValue
        }
    }
    
    /// Custom font for Card Action Buttons
    public class var cardActionButtonFont:UIFont{
        get{
            return WildcardSDK.sharedInstance.__cardActionButtonFont
        }set{
            WildcardSDK.sharedInstance.__cardActionButtonFont = newValue
        }
    }
}
