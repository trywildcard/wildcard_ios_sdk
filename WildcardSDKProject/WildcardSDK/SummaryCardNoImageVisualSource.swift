//
//  SummaryCardNoImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation


public class SummaryCardNoImageVisualSource : BaseVisualSource, CardViewVisualSource{
    
    var header:FullCardHeader!
    var body:SingleParagraphCardBody!
    var footer:ViewOnWebCardFooter!
    
    @objc public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.SimpleParagraph) as! SingleParagraphCardBody
            body.contentEdgeInset = UIEdgeInsetsMake(0, 15, 5, 15)
        }
        return body;
    }
    
    @objc public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader) as! FullCardHeader
            header.hairline.hidden = true
            header.logo.hidden = true
            header.contentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15)
        }
        return header
    }
    
    @objc public func viewForCardFooter()->CardViewElement?{
        if(footer == nil){
            footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter) as! ViewOnWebCardFooter
            footer.hairline.hidden = true
        }
        return footer
    }
}