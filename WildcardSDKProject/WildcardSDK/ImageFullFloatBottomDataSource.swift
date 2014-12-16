//
//  ImageFullFloatBottomDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class ImageFullFloatBottomDataSource : CardViewDataSource {
    
    var card:Card
    
    public init(card:Card){
        self.card = card
    }
    
    public func viewForCardHeader()->UIView?{
        if let headerView = UIView.loadFromNibNamed("FullCardHeader") as? FullCardHeader{
            headerView.updateForCard(card)
            return headerView
        }else{
            return nil
        }
    }
    
    public func heightForCardHeader()->CGFloat{
        return FullCardHeader.optimizedHeight(widthForCard(), card: card)
    }
    
    public func viewForCardBody()->UIView?{
        var bodyView = CenteredImageBody(frame:CGRectZero)
        bodyView.updateForCard(card)
        return bodyView
    }
    
    public func heightForCardBody()->CGFloat{
        return CenteredImageBody.optimizedHeight(widthForCard(), card: card)
    }
    
    public func viewForCardFooter()->UIView?{
        return nil
    }
    
    public func heightForCardFooter()->CGFloat{
        return 0
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
    
    public func backingCard() -> Card? {
        return card
    }
}