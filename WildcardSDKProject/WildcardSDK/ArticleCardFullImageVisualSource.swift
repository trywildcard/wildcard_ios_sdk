//
//  ArticleCardFullImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public class ArticleCardFullImageVisualSource : BaseVisualSource, CardViewVisualSource {
    
    var header:FullCardHeader
    var body:ImageAndCaptionBody
    var footer:ReadMoreFooter
    var aspectRatio:CGFloat
    var footerWeb:ViewOnWebCardFooter
    
    public init(card:Card, aspectRatio:CGFloat){
        self.aspectRatio = aspectRatio
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.header.hairline.hidden = true
        self.body = UIView.loadFromNibNamed("ImageAndCaptionBody") as ImageAndCaptionBody
        self.body.contentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15)
        self.body.imageAspectRatio = aspectRatio
        self.footer = ReadMoreFooter(frame:CGRectZero)
        self.footerWeb = ViewOnWebCardFooter(frame:CGRectZero)
        self.footerWeb.hairline.hidden = true
        super.init(card:card)
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
        let articleCard = card as ArticleCard
        if(articleCard.html == nil){
            return footerWeb
        }else{
            return footer
        }
    }
    
    public func heightForCardFooter() -> CGFloat {
        return 50
    }
    
    public override func widthForCard() -> CGFloat {
        return super.widthForCard();
    }
}