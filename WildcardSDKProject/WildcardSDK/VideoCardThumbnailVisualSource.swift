//
//  VideoCardThumbnailVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/27/15.
//
//

import Foundation

@objc
public class VideoCardThumbnailImageSource : BaseVisualSource, CardViewVisualSource{
    
    var body:VideoCardThumbnail!
    var back:SingleParagraphCardBody!
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(.VideoThumbnailBody) as! VideoCardThumbnail
        }
        return body;
    }
    
    public func viewForBackOfCard() -> CardViewElement? {
        if(back == nil){
            back = CardViewElementFactory.createCardViewElement(WCElementType.SimpleParagraph) as! SingleParagraphCardBody
        }
        return back;
    }
}