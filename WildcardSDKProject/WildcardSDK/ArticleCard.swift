//
//  ArticleCard.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/3/14.
//
//

import Foundation

/**
Article Card
*/
@objc
public class ArticleCard : Card{
    
    public let title:String
    public let creator:Creator
    public let abstractContent:String?
    
    public let keywords:[String]?
    public let html:String?
    public let publicationDate:NSDate?
    public let isBreaking:Bool?
    public let source:String?
    public let author:String?
    public let updatedDate:NSDate?
    public let media:NSDictionary?
    public let appLinkAndroid:NSURL?
    public let appLinkIos:NSURL?
    public let primaryImageURL:NSURL?
    
    public init(title:String, abstractContent:String, url:NSURL,creator:Creator, data:NSDictionary){
        self.title = title
        self.abstractContent = abstractContent
        self.creator = creator
        self.keywords = data["keywords"] as? [String]
        
        if let url = data["appLinkAndroid"] as? String{
            self.appLinkAndroid = NSURL(string: url)
        }
        if let url = data["appLinkIos"] as? String{
            self.appLinkIos = NSURL(string: url)
        }
        
        // optional fields from article data
        if let article = data["article"] as? NSDictionary{
            if let epochTime = article["publicationDate"] as? NSTimeInterval{
                self.publicationDate = NSDate(timeIntervalSince1970: epochTime/1000)
            }
            
            if let epochTime = article["updatedDate"] as? NSTimeInterval{
                self.updatedDate = NSDate(timeIntervalSince1970: epochTime/1000)
            }
            
            self.html = article["html"] as? String
            self.author = article["author"] as? String
            self.source = article["source"] as? String
            self.isBreaking = article["isBreaking"] as? Bool
            self.media = article["media"] as? NSDictionary
            
            if self.media != nil{
                if self.media!["type"] as String == "image"{
                    let imageUrl = self.media!["imageUrl"] as String
                    self.primaryImageURL = NSURL(string:imageUrl)
                }
            }
        }
        
        super.init(webUrl: url, cardType: "article")
    }
    
    override class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        var articleCard:ArticleCard?
        
        var startURL:NSURL?
        var title:String?
        var abstractContent:String?
        var creator:Creator?
        if let urlString = data["webUrl"] as? String{
            startURL = NSURL(string:urlString)
        }
        
        if let creatorData = data["creator"] as? NSDictionary{
            creator = Creator.deserializeFromData(creatorData) as? Creator
        }
        
        if let article = data["article"] as? NSDictionary{
            title = article["title"] as? String
            abstractContent = article["abstractContent"] as? String
            if(title != nil && abstractContent != nil && startURL != nil && creator != nil){
                articleCard = ArticleCard(title: title!, abstractContent: abstractContent!, url: startURL!, creator:creator!, data:data)
            }
        }
        return articleCard
    }
    
    public override func supportsLayout(layout: WCCardLayout) -> Bool {
        return layout == WCCardLayout.ArticleCard4x3FullImage ||
            layout == WCCardLayout.ArticleCard4x3SmallImage ||
            layout == WCCardLayout.ArticleCardNoImage
    }
    
}