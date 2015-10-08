//
//  CardViewElementFactory.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 2/13/15.
//
//

import Foundation


public class CardViewElementFactory{
    
    /** 
    Creates a CardViewElement from WCElementType. You may not make any assumptions about the size after this call.
    
    Use only for initialization
    */
    public class func createCardViewElement(type:WCElementType)->CardViewElement{
        
        var cardViewElement:CardViewElement!
        
        switch(type){
        case .FullHeader:
            cardViewElement = UIView.loadFromNibNamed("FullCardHeader") as! FullCardHeader
        case .TwitterHeader:
            cardViewElement = UIView.loadFromNibNamed("TwitterHeader") as! TwitterHeader
        case .ImageAndCaption:
            cardViewElement = UIView.loadFromNibNamed("ImageAndCaptionBody") as! ImageAndCaptionBody
        case .ImageOnly:
            cardViewElement = ImageOnlyBody(frame:CGRectZero);
        case .MediaTextFullWebView:
            cardViewElement = UIView.loadFromNibNamed("MediaTextFullWebView") as! MediaTextFullWebView
        case .ImageFloatRight:
            cardViewElement = UIView.loadFromNibNamed("ImageFloatRightBody") as! ImageFloatRightBody
        case .ImageFloatLeft:
            cardViewElement = UIView.loadFromNibNamed("ImageFloatLeftBody") as! ImageFloatLeftBody
        case .ReadMoreFooter:
            cardViewElement = ReadMoreFooter(frame:CGRectZero);
        case .ViewOnWebFooter:
            cardViewElement = ViewOnWebCardFooter(frame:CGRectZero);
        case .SimpleParagraph:
            cardViewElement = SingleParagraphCardBody(frame:CGRectZero);
        case .VideoBody:
            cardViewElement = VideoCardBody(frame:CGRectZero);
        case .VideoThumbnailBody:
            cardViewElement = VideoCardThumbnail(frame:CGRectZero);
        }
        return cardViewElement
    }
}