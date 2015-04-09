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
    public let appLinkIos:NSURL?
    public let primaryImageURL:NSURL?
    
    public init(title:String, abstractContent:String, url:NSURL,creator:Creator, data:NSDictionary){
        self.title = title
        self.abstractContent = abstractContent
        self.creator = creator
        self.keywords = data["keywords"] as? [String]
        
        if let url = data["appLinkIos"] as? String{
            self.appLinkIos = NSURL(string: url)
        }else{
            self.appLinkIos = nil
        }
        
        var cardHtml:String?
        var cardPublicationDate:NSDate?
        var cardUpdatedDate:NSDate?
        var cardIsBreaking:Bool?
        var cardAuthor:String?
        var cardSource:String?
        var cardMedia:NSDictionary?
        var cardPrimaryImageURL:NSURL?
        
        // optional fields from article data
        if let article = data["article"] as? NSDictionary{
            if let epochTime = article["publicationDate"] as? NSTimeInterval{
                cardPublicationDate = NSDate(timeIntervalSince1970: epochTime/1000)
            }
            
            if let epochTime = article["updatedDate"] as? NSTimeInterval{
                cardUpdatedDate = NSDate(timeIntervalSince1970: epochTime/1000)
            }
            
            cardHtml = article["htmlContent"] as? String
            cardAuthor = article["author"] as? String
            cardSource = article["source"] as? String
            cardIsBreaking = article["isBreaking"] as? Bool
            cardMedia = article["media"] as? NSDictionary
            
            if let media = cardMedia{
                if media["type"] as! String == "image"{
                    let imageUrl = media["imageUrl"] as! String
                    cardPrimaryImageURL = NSURL(string:imageUrl)
                }
            }
        }
        
        self.html = cardHtml
        self.publicationDate = cardPublicationDate;
        self.updatedDate = cardUpdatedDate
        self.isBreaking = cardIsBreaking;
        self.source = cardSource
        self.author = cardAuthor
        self.media = cardMedia
        self.primaryImageURL = cardPrimaryImageURL
        
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
        return layout == WCCardLayout.ArticleCardTall ||
            layout == WCCardLayout.ArticleCardShort ||
            layout == WCCardLayout.ArticleCardNoImage
    }
    
}