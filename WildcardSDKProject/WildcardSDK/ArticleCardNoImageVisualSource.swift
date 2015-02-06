//
//  ArticleCardNoImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

@objc
public class ArticleCardNoImageVisualSource : BaseVisualSource, CardViewVisualSource {
    
    var header:FullCardHeader
    var body:SingleParagraphCardBody
    var footer:ReadMoreFooter
    var footerWeb:ViewOnWebCardFooter
    
    public override init(card:Card){
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.header.hairline.hidden = true
        self.body = SingleParagraphCardBody(frame:CGRectZero)
        self.body.paragraphLabelEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15)
        self.footer = ReadMoreFooter(frame:CGRectZero)
        self.footerWeb = ViewOnWebCardFooter(frame:CGRectZero)
        self.footerWeb.hairline.hidden = true
        
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