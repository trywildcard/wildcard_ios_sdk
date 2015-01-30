//
//  SummaryCardNoImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public class SummaryCardNoImageVisualSource : CardViewVisualSource{
    
    var card:Card
    var header:FullCardHeader
    var body:SingleParagraphCardBody
    var footer:ViewOnWebCardFooter
    
    public init(card:Card){
        self.card = card
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        header.hairline.hidden = true
        header.logo.hidden = true
        //header.titleOffset = UIOffsetMake(15, header.titleOffset.vertical)
        self.body = SingleParagraphCardBody(frame:CGRectZero)
        body.paragraphLabelEdgeInsets = UIEdgeInsetsMake(0, 15, 5, 15)
        self.footer = ViewOnWebCardFooter(frame:CGRectZero)
        self.footer.viewOnWebButtonOffset = UIOffsetMake(15, 0)
        footer.hairline.hidden = true
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
    
    public func widthForCard()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        if(screenBounds.width > screenBounds.height){
            return screenBounds.height - (2 * WildcardSDK.cardScreenMargin)
        }else{
            return screenBounds.width - (2 * WildcardSDK.cardScreenMargin)
        }
    }
    
}