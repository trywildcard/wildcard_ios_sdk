//
//  ImageCardTallVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/31/15.
//
//

import Foundation


public class ImageCardTallVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:ImageOnlyBody!
    var body:FullCardHeader!
    var aspectRatio:CGFloat
    
    public init(card:Card, aspectRatio:CGFloat){
        self.aspectRatio = aspectRatio
        super.init(card:card)
    }
    
    public override init(card:Card){
        // default aspect ratio at 3:4
        aspectRatio = 0.75
        
        // assign aspect ratio if we have it
        if let videoCard = card as? ImageCard{
            if (videoCard.imageSize != CGSizeMake(-1, -1)){
                aspectRatio = videoCard.imageSize.height / videoCard.imageSize.width
            }
        }
        
        super.init(card: card)
    }
    
    @objc public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(WCElementType.ImageOnly) as! ImageOnlyBody
            header.contentEdgeInset = UIEdgeInsetsMake(0,0,0,0)
            header.imageAspectRatio = aspectRatio
        }
        return header
    }
    
    @objc public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader) as! FullCardHeader
            body.contentEdgeInset = UIEdgeInsetsMake(15, 15, 15, 15)
            body.logo.hidden = true
            body.hairline.hidden = true
        }
        return body
    }
}