//
//  ImageCardImageOnlyVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/31/15.
//
//

import Foundation


public class ImageCardImageOnlyVisualSource : BaseVisualSource, CardViewVisualSource
{
    var body:ImageOnlyBody!
    var aspectRatio:CGFloat
    
    public init(card:Card, aspectRatio:CGFloat){
        self.aspectRatio = aspectRatio
        super.init(card:card)
    }
    
    @objc public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(.ImageOnly) as! ImageOnlyBody
            body.contentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0)
            body.imageAspectRatio = aspectRatio
        }
        return body
    }
}