//
//  VideoCard.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/9/15.
//
//

import Foundation

/**
Video Card
*/
@objc
public class VideoCard : Card{
    
    public let title:String
    public let creator:Creator
    public let embedUrl:NSURL
    
    public let abstractContent:String?
    public let keywords:[String]?
    public let appLinkIos:NSURL?
    public let streamUrl:NSURL?
    public let streamContentType:String?
    public let posterImageUrl:NSURL?
    
    public init(title:String, embedUrl:NSURL, url:NSURL,creator:Creator, data:NSDictionary){
        
        self.title = title
        self.creator = creator
        self.embedUrl = embedUrl
        self.keywords = data["keywords"] as? [String]
        
        if let url = data["appLinkIos"] as? String{
            self.appLinkIos = NSURL(string: url)
        }else{
            self.appLinkIos = nil
        }
        
        var cardAbstractContent:String?
        var cardPosterImageUrl:NSURL?
        var cardStreamContentType:String?
        var cardStreamUrl:NSURL?
        
        if let media = data["media"] as? NSDictionary{
            
            if let description = media["description"] as? String{
                cardAbstractContent = description
            }
            
            if let imageUrl = media["posterImageUrl"] as? String{
                cardPosterImageUrl = NSURL(string:imageUrl);
            }
            
            if let contentType = media["streamContentType"] as? String{
                cardStreamContentType = contentType
            }
            
            if let streamUrlString = media["streamUrl"] as? String{
                cardStreamUrl = NSURL(string: streamUrlString)
            }
        }
        
        self.abstractContent = cardAbstractContent
        self.posterImageUrl = cardPosterImageUrl
        self.streamContentType = cardStreamContentType
        self.streamUrl = cardStreamUrl
        
        super.init(webUrl: url, cardType: "video")
    }
    
    override class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        
        var videoCard:VideoCard?
        
        var startURL:NSURL?
        var title:String?
        var creator:Creator?
        var embeddedURL:NSURL?
        
        if let urlString = data["webUrl"] as? String{
            startURL = NSURL(string:urlString)
        }
        
        if let creatorData = data["creator"] as? NSDictionary{
            creator = Creator.deserializeFromData(creatorData) as? Creator
        }
        
        if let media = data["media"] as? NSDictionary{
            title = media["title"] as? String
            
            if let urlString = media["embeddedUrl"] as? String{
                embeddedURL = NSURL(string:urlString)
            }
            
            if(title != nil && startURL != nil && creator != nil && embeddedURL != nil){
                videoCard = VideoCard(title: title!, embedUrl:embeddedURL!, url: startURL!, creator:creator!, data:data)
            }
        }
        return videoCard
        
    }
    
    public func isYoutube()->Bool{
        return creator.name == "Youtube"
    }
    
    public func isVimeo()->Bool{
        return creator.name == "Vimeo"
    }
    
    public func getYoutubeId()->String?{
        let ytEmbedRegex = "^http(s)://(www.)youtube.com/embed/(.*)$"
        let regex = try? NSRegularExpression(pattern: ytEmbedRegex, options: NSRegularExpressionOptions.CaseInsensitive)
        
        let length:Int = embedUrl.absoluteString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let ytMatch = regex?.firstMatchInString(embedUrl.absoluteString, options: NSMatchingOptions(), range: NSMakeRange(0, length))
        if(ytMatch != nil){
            return embedUrl.lastPathComponent
        }else{
            return nil
        }
    }

    public override func supportsLayout(layout: WCCardLayout) -> Bool {
        return layout == .VideoCardShort ||
               layout == .VideoCardThumbnail ||
                layout == .VideoCardShortFull
    }

}