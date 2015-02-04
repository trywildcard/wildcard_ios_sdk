//
//  SummaryCardNoImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public class SummaryCardNoImageVisualSource : BaseVisualSource, CardViewVisualSource{
    
    var header:FullCardHeader
    var body:SingleParagraphCardBody
    var footer:ViewOnWebCardFooter
    
    public override init(card:Card){
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        header.hairline.hidden = true
        header.logo.hidden = true
        header.contentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15)
        self.body = SingleParagraphCardBody(frame:CGRectZero)
        body.paragraphLabelEdgeInsets = UIEdgeInsetsMake(0, 15, 5, 15)
        self.footer = ViewOnWebCardFooter(frame:CGRectZero)
        self.footer.viewOnWebButtonOffset = UIOffsetMake(15, 0)
        footer.hairline.hidden = true
        super.init(card:card)
    }
    
    public func viewForCardHeader()->CardViewElement?{
        return header
    }
    
    public func heightForCardHeader()->CGFloat{
        return header.optimizedHeight(widthForCard())
    }
    
    public func viewForCardBody()->CardViewElement{
        return body;
    }
    
    public func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func viewForCardFooter()->CardViewElement?{
        return footer
    }
    
    public func heightForCardFooter()->CGFloat{
        return footer.optimizedHeight(widthForCard())
    }
    
    public override func widthForCard() -> CGFloat {
        return super.widthForCard();
    }
}