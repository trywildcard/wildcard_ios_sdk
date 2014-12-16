//
//  ImageThumbnailFloatLeftDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class ImageThumbnailFloatLeftDataSource : CardViewDataSource {
    
    var card:Card
    
    public init(card:Card){
        self.card = card
    }
    
    public func viewForCardHeader()->UIView?{
        return nil
    }
    
    public func heightForCardHeader()->CGFloat{
        return 0
    }
    
    public func viewForCardBody()->UIView?{
        if let bodyView = UIView.loadFromNibNamed("ImageThumbnailFloatLeft") as? ImageThumbnailFloatLeft{
            bodyView.updateForCard(card)
            return bodyView
        }else{
            return nil
        }
    }
    
    public func heightForCardBody()->CGFloat{
        return 140
    }
    
    public func viewForCardFooter()->UIView?{
        let footer = ViewOnWebCardFooter(frame:CGRectZero)
        footer.updateForCard(card)
        return footer
    }
    
    public func heightForCardFooter()->CGFloat{
        return 40.5
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