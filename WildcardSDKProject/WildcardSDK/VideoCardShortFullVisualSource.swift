//
//  VideoCardShortFullVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/15/15.
//
//

import Foundation


public class VideoCardShortFullVisualSource : BaseVisualSource, CardViewVisualSource{
    
    var header:VideoCardBody!
    var body:FullCardHeader!
    
    @objc public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(WCElementType.VideoBody) as! VideoCardBody
            header.videoAspectRatio = 0.5625 // 16:9 default for videos
            header.contentEdgeInset = UIEdgeInsetsMake(0,0,0,0)
        }
        return header
    }
    
    @objc public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader) as! FullCardHeader
            body.contentEdgeInset = UIEdgeInsetsMake(15, 15, 15, 15)
            body.title.numberOfLines = 2
            body.logo.hidden = true
            body.hairline.hidden = true
        }
        return body;
    }
}