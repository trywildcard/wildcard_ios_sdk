//
//  BareBonesCardDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

/**
A Placeholder Visual Source. Do not use this.
*/
@objc
public class PlaceholderCardVisualSource : CardViewVisualSource{
    
    var card:Card
    
    public init(card:Card){
        self.card = card
    }
    
    public func viewForCardBody()->CardViewElement{
        return PlaceholderCardBody(frame:CGRectZero)
    }
    
    public func heightForCardBody()->CGFloat{
        return  widthForCard() * (3/4)
    }
    
    public func widthForCard()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        if(screenBounds.width > screenBounds.height){
            return screenBounds.height - (2 * WildcardSDK.cardScreenMargin)
        }else{
            return screenBounds.width - (2 * WildcardSDK.cardScreenMargin)
        }
    }
}