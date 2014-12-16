//
//  SimpleDescriptionCardDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class SimpleDescriptionCardDataSource : CardViewDataSource{
    
    var card:Card
    
    public init(card:Card){
        self.card = card
    }
    
    public func viewForCardHeader()->UIView?{
        var headerView:CardViewElement = OneLineCardHeader(frame:CGRectZero)
        headerView.updateForCard(card)
        return headerView
    }
    
    public func heightForCardHeader()->CGFloat{
        return 41;
    }
    
    public func viewForCardBody()->UIView?{
        var bodyView:CardViewElement = SingleParagraphCardBody(frame:CGRectZero)
        bodyView.updateForCard(card)
        return bodyView
    }
    
    public func heightForCardBody()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        let defaultMargins:CGFloat = 15.0
        let cardWidth = screenBounds.width - (2*defaultMargins)
        return SingleParagraphCardBody.optimizedHeight(cardWidth, card: card) 
    }
    
    public func viewForCardFooter()->UIView?{
        return nil;
    }
    
    public func heightForCardFooter()->CGFloat{
        return 0;
    }
    
    public func viewForBackOfCard()->UIView?{
        let emptyBack = EmptyCardBack(frame:CGRectZero)
        return emptyBack
    }
    
    public func widthForCard()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        let defaultMargins:CGFloat = 15.0
        let cardWidth = screenBounds.width - (2*defaultMargins)
        return cardWidth
    }
    
    
}