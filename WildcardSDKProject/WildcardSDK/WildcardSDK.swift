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
    
    /// Card Corner Radius
    public class var cardCornerRadius:CGFloat{
        get{
            return WildcardSDK.sharedInstance.__cardCornerRadius
        }set{
            WildcardSDK.sharedInstance.__cardCornerRadius = newValue
        }
    }
    
    /// Delegate queue for network request callbacks
    public class var networkDelegateQueue:NSOperationQueue{
        get{
            return WildcardSDK.sharedInstance.__networkDelegateQueue;
        }set{
            WildcardSDK.sharedInstance.__networkDelegateQueue = newValue;
        }
    }
    
    /// Initialize the SDK
    public class func initializeWithApiKey(key:String){
        if(WildcardSDK.sharedInstance.__applicationKey == nil){
            WildcardSDK.sharedInstance.__applicationKey = key
            WildcardSDK.sharedInstance.__analytics = WCAnalytics(key:key)
        }else{
            println("Wildcard SDK can only be initialized once.")
        }
    }
    
    class var analytics:WCAnalytics?{
        get{
            return WildcardSDK.sharedInstance.__analytics;
        }
    }
    
    class var apiKey:String?{
        get{
            return WildcardSDK.sharedInstance.__applicationKey;
        }
    }
    
    var __cardCornerRadius:CGFloat = 4.0
    var __cardTitleFont:UIFont!
    var __cardKickerFont:UIFont!
    var __cardDescriptionFont:UIFont!
    var __cardActionButtonFont:UIFont!
    var __applicationKey:String?
    var __analytics:WCAnalytics?
    var __networkDelegateQueue:NSOperationQueue!
    
    class var sharedInstance : WildcardSDK{
        struct Static{
            static var onceToken : dispatch_once_t = 0
            static var instance : WildcardSDK? = nil
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = WildcardSDK()
            Static.instance!.__cardTitleFont = UIFont(name:"HelveticaNeue-Medium", size: 16.0)!
            Static.instance!.__cardKickerFont = UIFont(name:"HelveticaNeue-Medium", size: 12.0)!
            Static.instance!.__cardDescriptionFont = UIFont(name:"HelveticaNeue", size: 12.0)!
            Static.instance!.__cardActionButtonFont = UIFont(name:"HelveticaNeue-Medium", size: 12.0)!
            Static.instance!.__networkDelegateQueue = NSOperationQueue.mainQueue()
        })
        return Static.instance!
    }
}
