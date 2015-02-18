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
    var widthOverride:CGFloat? = nil
    let defaultCardMargin:CGFloat
    
    /// Initiailize with backing card and card margin to screen bounds
    public init(card:Card, margin:CGFloat){
        self.card = card
        self.defaultCardMargin = margin;
    }
    
    /// Initialize with backing card and default card margin of 15
    public init(card:Card){
        self.card = card
        self.defaultCardMargin = 15.0
    }

    /**
    If portrait, the width is defaulted to the screen width - (2 * margin)
    
    If landscape, the width is defaulted to the screen height - (2 * margin)
    
    widthOverride is used if it's set.
    */
    public func widthForCard()->CGFloat{
        if(widthOverride == nil){
            let screenBounds = UIScreen.mainScreen().bounds
            if(screenBounds.width > screenBounds.height){
                return screenBounds.height - (2 * defaultCardMargin)
            }else{
                return screenBounds.width - (2 * defaultCardMargin)
            }
        }else{
            return widthOverride!
        }
    }
}