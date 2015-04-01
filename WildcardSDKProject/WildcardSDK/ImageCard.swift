//
//  ImageCard.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/31/15.
//
//

import Foundation

/**
Image Card
*/
@objc
public class ImageCard : Card{
    
    public let creator:Creator
    public let imageUrl:NSURL
    
    /// optional size for the image. will be (-1,-1) if size is unavailable
    public let imageSize:CGSize
    
    public let title:String?
    public let imageCaption:String?
    public let keywords:[String]?
    public let appLinkAndroid:NSURL?
    public let appLinkIos:NSURL?
    
    public init(imageUrl:NSURL, url:NSURL,creator:Creator, data:NSDictionary){
        
        self.creator = creator
        self.keywords = data["keywords"] as? [String]
        self.imageUrl = imageUrl
        self.imageSize = CGSizeMake(-1.0, -1.0)
        
        if let url = data["appLinkAndroid"] as? String{
            self.appLinkAndroid = NSURL(string: url)
        }
        if let url = data["appLinkIos"] as? String{
            self.appLinkIos = NSURL(string: url)
        }
        
        if let media = data["media"] as? NSDictionary{
            
            if let title = media["title"] as? String{
                self.title = title
            }
            
            if let caption = media["imageCaption"] as? String{
                self.imageCaption = caption
            }
            
            if let width = media["width"] as? CGFloat {
                if let height = media["height"] as? CGFloat {
                    self.imageSize = CGSizeMake(width, height)
                }
            }
        }
        
        super.init(webUrl: url, cardType: "image")
    }
    
    override class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        
        var imageCard:ImageCard?
        
        var startURL:NSURL?
        var creator:Creator?
        var imageUrl:NSURL?
        
        if let urlString = data["webUrl"] as? String{
            startURL = NSURL(string:urlString)
        }
        
        if let creatorData = data["creator"] as? NSDictionary{
            creator = Creator.deserializeFromData(creatorData) as? Creator
        }
        
        if let media = data["media"] as? NSDictionary{
            
            if let urlString = media["imageUrl"] as? String{
                imageUrl = NSURL(string:urlString)
            }
            
            if(startURL != nil && creator != nil && imageUrl != nil){
                imageCard = ImageCard(imageUrl:imageUrl!, url: startURL!, creator:creator!, data:data)
            }
        }
        return imageCard
        
    }
    
    public override func supportsLayout(layout: WCCardLayout) -> Bool {
        return  layout == .ImageCard4x3 ||
                layout == .ImageCardAspectFit ||
                layout == .ImageCardImageOnly
    }
}