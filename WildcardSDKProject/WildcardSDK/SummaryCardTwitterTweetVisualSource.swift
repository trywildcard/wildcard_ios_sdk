//
//  SummaryCardTwitterTweetVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/23/15.
//
//

import Foundation


public class SummaryCardTwitterTweetVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:TwitterHeader!
    var body:SingleParagraphCardBody!
    
    @objc public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(.TwitterHeader) as! TwitterHeader
        }
        return header
    }
    
    @objc public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(.SimpleParagraph) as! SingleParagraphCardBody
            body.contentEdgeInset = UIEdgeInsetsMake(0, 20, 22, 20)
            body.paragraphLabel.textColor = UIColor.wildcardDarkBlue()
            body.paragraphLabel.font = UIFont(name:"HelveticaNeue-Light", size: 18.0)!
        }
        return body
    }
}