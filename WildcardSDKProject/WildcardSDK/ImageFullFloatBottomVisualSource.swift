//
//  ImageFullFloatBottomDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class ImageFullFloatBottomVisualSource : CardViewVisualSource {
    
    var card:Card
    var header:FullCardHeader
    var body:ImageAndCaptionBody
    var footer:ReadMoreFooter
    
    public init(card:Card){
        self.card = card
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.header.bottomHairline.hidden = true
        self.body = UIView.loadFromNibNamed("ImageAndCaptionBody") as ImageAndCaptionBody
        self.body.contentEdgeInset = UIEdgeInsetsMake(0, 10, 5, 10)
        self.footer = ReadMoreFooter(frame:CGRectZero)
    }
    
    public func viewForCardHeader()->CardViewElement?{
        return header
    }
    
    public func heightForCardHeader()->CGFloat{
        return header.optimizedHeight(widthForCard())
    }
    
    public func viewForCardBody()->CardViewElement{
        return body
    }
    
    public func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        return footer
    }
    
    public func heightForCardFooter() -> CGFloat {
        return footer.optimizedHeight(widthForCard())
    }
    
    public func viewForBackOfCard()->CardViewElement?{
        return EmptyCardBack(frame:CGRectZero)
    }
    
    public func widthForCard()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        let defaultMargins:CGFloat = 15.0
        let cardWidth = screenBounds.width - (2*defaultMargins)
        return cardWidth
    }
}