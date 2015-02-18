//
//  ArticleCardFullImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

@objc
public class ArticleCardFullImageVisualSource : BaseVisualSource, CardViewVisualSource {
    
    var header:FullCardHeader!
    var body:ImageAndCaptionBody!
    var footer:ReadMoreFooter!
    var aspectRatio:CGFloat
    var footerWeb:ViewOnWebCardFooter!
    
    public init(card:Card, aspectRatio:CGFloat){
        self.aspectRatio = aspectRatio
        super.init(card:card)
    }
    
    public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader, preferredWidth:widthForCard()) as FullCardHeader
            header.hairline.hidden = true
        }
        return header
    }
    
    public func heightForCardHeader()->CGFloat{
        return header.optimizedHeight(widthForCard())
    }
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            self.body = CardViewElementFactory.createCardViewElement(WCElementType.ImageAndCaption, preferredWidth:widthForCard()) as ImageAndCaptionBody
            self.body.contentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15)
            self.body.imageAspectRatio = aspectRatio
        }
        return body
    }
    
    public func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        if let articleCard = card as? ArticleCard{
            if(articleCard.html == nil){
                if(footerWeb == nil){
                    self.footerWeb = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter, preferredWidth:widthForCard()) as ViewOnWebCardFooter
                    self.footerWeb.hairline.hidden = true
                }
                return footerWeb
            }else{
                if(footer == nil){
                    self.footer = CardViewElementFactory.createCardViewElement(WCElementType.ReadMoreFooter, preferredWidth:widthForCard()) as ReadMoreFooter
                    self.footer.contentEdgeInset = UIEdgeInsetsMake(15, 15, 15, 15)
                }
                return footer
            }
        }else{
            return nil
        }
    }
    
    public func heightForCardFooter() -> CGFloat {
        return 50
    }
    
    public override func widthForCard() -> CGFloat {
        return super.widthForCard();
    }
}