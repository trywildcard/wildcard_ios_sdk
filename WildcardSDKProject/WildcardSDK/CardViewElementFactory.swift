//
//  CardViewElementFactory.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 2/13/15.
//
//

import Foundation

@objc
public class CardViewElementFactory{
    
    /** 
    Creates a CardViewElement by enumeration. You may not make any assumptions about the size after this call.
    
    Use only for initialization
    */
    public class func createCardViewElement(type:WCElementType, preferredWidth:CGFloat)->CardViewElement{
        
        var cardViewElement:CardViewElement!
        
        switch(type){
        case .FullHeader:
            cardViewElement = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        case .ImageAndCaption:
            cardViewElement = UIView.loadFromNibNamed("ImageAndCaptionBody") as ImageAndCaptionBody
        case .ImageOnly:
            cardViewElement = ImageOnlyBody(frame:CGRectZero);
        case .MediaTextFullWebView:
            cardViewElement = UIView.loadFromNibNamed("MediaTextFullWebView") as MediaTextFullWebView
        case .MediaTextWrapImageFloatsRight:
            cardViewElement = UIView.loadFromNibNamed("MediaTextImageFloatRight") as MediaTextImageFloatRight
        case .ImageFloatsRight:
            cardViewElement = UIView.loadFromNibNamed("ImageFloatRightBody") as ImageFloatRightBody
        case .ReadMoreFooter:
            cardViewElement = ReadMoreFooter(frame:CGRectZero);
        case .ViewOnWebFooter:
            cardViewElement = ViewOnWebCardFooter(frame:CGRectZero);
        case .SimpleParagraph:
            cardViewElement = SingleParagraphCardBody(frame:CGRectZero);
        }
        
        cardViewElement.preferredWidth = preferredWidth
        cardViewElement.initializeElement()
        return cardViewElement
        
    }
}