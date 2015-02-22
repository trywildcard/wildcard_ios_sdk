//
//  MaximizedArticleDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/18/14.
//
//

import Foundation

public class MaximizedArticleVisualSource : MaximizedCardViewVisualSource {
    
    var card:Card
    var body:MediaTextFullWebView!
    
    public init(card:Card){
        self.card = card
    }
    
    public func applicationFrameEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.MediaTextFullWebView) as MediaTextFullWebView
        }
        return body
    }
    
    public func heightForCardBody()->CGFloat{
        // must be relative to application frame and insets
        let frame = UIScreen.mainScreen().applicationFrame
        let insets = applicationFrameEdgeInsets()
        return frame.size.height - insets.top - insets.bottom
    }
    
    public func widthForCard()->CGFloat{
        // must be relative to application frame and insets
        let frame = UIScreen.mainScreen().applicationFrame
        let insets = applicationFrameEdgeInsets()
        return frame.width - insets.left - insets.right
    }
}