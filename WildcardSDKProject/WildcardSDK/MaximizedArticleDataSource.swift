//
//  MaximizedArticleDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/18/14.
//
//

import Foundation

public class MaximizedArticleDataSource : CardViewDataSource {
    
    var card:Card
    
    public init(card:Card){
        self.card = card
    }
    
    public func viewForCardBody()->UIView?{
        return UIView.loadFromNibNamed("MediaTextFullWebView") as? MediaTextFullWebView
    }
    
    public func heightForCardBody()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        let cardHeight = screenBounds.height - 35
        return cardHeight
    }
    
    public func widthForCard()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        let defaultMargins:CGFloat = 10.0
        let cardWidth = screenBounds.width - (2*defaultMargins)
        return cardWidth
    }
    
    public func backingCard() -> Card? {
        return card
    }
}