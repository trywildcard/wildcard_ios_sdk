//
//  BaseVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/30/15.
//
//

import Foundation

/// DO NOT instantiate. You may derive from this if you are customizing your own visual source.
@objc
public class BaseVisualSource
{
    let card:Card
    var preferredWidth:CGFloat? = nil
    
    /// Initialize with backing card a
    public init(card:Card){
        self.card = card
    }

    /**
    If portrait, the width is defaulted to the screen width - (2 * WildcardSDK.defaultScreenMargin)
    
    If landscape, the width is defaulted to the screen height - (2 * WildcardSDK.defaultScreenMargin)
    
    preferredWidth is used if it's set.
    */
    public func widthForCard()->CGFloat{
        if(preferredWidth == nil){
            let screenBounds = UIScreen.mainScreen().bounds
            if(screenBounds.width > screenBounds.height){
                return screenBounds.height - (2 * WildcardSDK.defaultScreenMargin)
            }else{
                return screenBounds.width - (2 * WildcardSDK.defaultScreenMargin)
            }
        }else{
            return preferredWidth!
        }
    }
}