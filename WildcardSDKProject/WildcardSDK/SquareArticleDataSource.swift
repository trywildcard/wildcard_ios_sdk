//
//  SquareArticleNoImageDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class SquareArticleDataSource : CardViewDataSource {
    
    var card:Card
    
    public init(card:Card){
        self.card = card
    }
    
    public func viewForCardHeader()->UIView?{
        if let headerView = UIView.loadFromNibNamed("FullCardHeader") as? FullCardHeader{
            return headerView
        }else{
            return nil
        }
    }
    
    public func heightForCardHeader()->CGFloat{
        return FullCardHeader.optimizedHeight(widthForCard(), card: card)
    }
    
    public func viewForCardBody()->UIView?{
        if let bodyView = UIView.loadFromNibNamed("MediaTextImageFloatRight") as? MediaTextImageFloatRight{
            return bodyView
        }else{
            return nil
        }
    }
    
    public func heightForCardBody()->CGFloat{
        return widthForCard() - heightForCardFooter() - heightForCardHeader()
    }
    
    public func viewForBackOfCard()->UIView?{
        let emptyBack = EmptyCardBack(frame:CGRectZero)
        return emptyBack
    }
    
    public func viewForCardFooter() -> UIView? {
        let footer = TallReadMoreFooter(frame:CGRectZero)
        return footer
    }
    
    public func heightForCardFooter() -> CGFloat {
        return 65
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