//
//  SummaryCardTwitterProfileVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/23/15.
//
//

import Foundation

@objc
public class SummaryCardTwitterProfileVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:ImageOnlyBody!
    var body:FullCardHeader!
    var footer:ViewOnWebCardFooter!
    
    public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(.ImageOnly) as! ImageOnlyBody
            header.contentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return header
    }
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(.FullHeader) as! FullCardHeader
            body.contentEdgeInset = UIEdgeInsetsMake(15, 15, 0, 15)
            body.logo.hidden = true
            body.hairline.hidden = true
        }
        return body
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        if(footer == nil){
            footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter) as! ViewOnWebCardFooter
            footer.hairline.hidden = true
            footer.contentEdgeInset = UIEdgeInsetsMake(15, 15, 10, 15)
        }
        return footer
    }
}