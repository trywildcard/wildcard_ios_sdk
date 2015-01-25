//
//  WildcardSDK.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/22/15.
//
//

import Foundation

/// Global properties to customize Card Views
@objc
public class WildcardSDK {
    
    /**
    Card dimensions are calculated relative to the screen dimensions with a default margin of 15 points.
    
    We assume the most common use-case where a Card View is center-aligned on screen. This is the margin from the card to the horizontal or vertical edges of screen. You may use this convenience method to set a custom margin.
    
    This is the easiest way to change Card dimensions. For full dimension customization, you must implement your own card visual source.
    */
    public class var cardScreenMargin:CGFloat{
        get{
            return WildcardSDK.sharedInstance.__cardScreenMargin
        }set{
            WildcardSDK.sharedInstance.__cardScreenMargin = newValue
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
    
    // MARK: Private
    var __cardScreenMargin:CGFloat = 15
    var __cardTitleFont:UIFont!
    var __cardKickerFont:UIFont!
    var __cardDescriptionFont:UIFont!
    var __cardActionButtonFont:UIFont!
    
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
}
