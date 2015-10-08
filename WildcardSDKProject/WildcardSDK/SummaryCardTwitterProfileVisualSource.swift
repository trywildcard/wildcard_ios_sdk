//
//  SummaryCardTwitterProfileVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/23/15.
//
//

import Foundation


public class SummaryCardTwitterProfileVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:ImageOnlyBody!
    var body:TwitterHeader!
    var footer:SingleParagraphCardBody!
    
    @objc public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(.ImageOnly) as! ImageOnlyBody
            header.contentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return header
    }
    
    @objc public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(.TwitterHeader) as! TwitterHeader
        }
        return body
    }
    
    @objc public func viewForCardFooter() -> CardViewElement? {
        if(footer == nil){
            footer = CardViewElementFactory.createCardViewElement(.SimpleParagraph) as! SingleParagraphCardBody
            footer.contentEdgeInset = UIEdgeInsetsMake(0, 20, 22, 20)
            footer.paragraphLabel.textColor = UIColor.wildcardDarkBlue()
            footer.paragraphLabel.font = UIFont(name:"HelveticaNeue-Light", size: 18.0)!
        }
        return footer
        
    }
}