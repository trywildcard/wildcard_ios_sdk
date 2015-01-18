//
//  SummaryCard4x3FloatRightImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public class SummaryCard4x3FloatRightImageVisualSource : CardViewVisualSource {
    
    var card:Card
    var body:ImageThumbnail4x3FloatRight
    
    public init(card:Card){
        self.card = card
        self.body = UIView.loadFromNibNamed("ImageThumbnail4x3FloatRight") as ImageThumbnail4x3FloatRight
    }
    
    public func viewForCardBody()->CardViewElement{
        return body
    }
    
    public func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func widthForCard()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        let defaultMargins:CGFloat = 15.0
        let cardWidth = screenBounds.width - (2*defaultMargins)
        return cardWidth
    }
}