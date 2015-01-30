//
//  SummaryCardLandscapeImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/24/15.
//
//

import Foundation

public class SummaryCardSmallImageVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:FullCardHeader
    var body:ImageFloatRightBody
    var footer:ViewOnWebCardFooter
    
    public override init(card:Card){
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.header.hairline.hidden = true
        self.body = UIView.loadFromNibNamed("ImageFloatRightBody") as ImageFloatRightBody
        self.body.contentEdgeInset = UIEdgeInsetsMake(5, 15, 5, 15)
        self.footer = ViewOnWebCardFooter(frame:CGRectZero)
        self.footer.hairline.hidden = true
        self.footer.viewOnWebButtonOffset = UIOffsetMake(15, self.footer.viewOnWebButtonOffset.vertical)
        super.init(card: card)
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
        return 50
    }
    
    public override func widthForCard() -> CGFloat {
        return super.widthForCard();
    }
    
}