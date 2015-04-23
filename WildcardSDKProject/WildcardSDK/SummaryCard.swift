//
//  WebLinkCard.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

/**
Summary Card
*/
@objc
public class SummaryCard : Card {
    
    public let title:String
    public let abstractContent:String
    public let subtitle:String?
    public let media:NSDictionary?
    public let primaryImageURL:NSURL?
    public let appLinkIos:NSURL?
    
    public init(url:NSURL, description:String, title:String, media:NSDictionary?, data:NSDictionary?){
        self.title = title
        self.abstractContent = description
        self.media = media
        
        var cardPrimaryImageURL:NSURL?
        var cardAppLinkIos:NSURL?
        var subtitle:String?
        
        if let dataDict = data{
            if let url = dataDict["appLinkIos"] as? String{
                cardAppLinkIos = NSURL(string: url)
            }
            if let summary = dataDict["summary"] as? NSDictionary{
                subtitle = summary["subtitle"] as? String
            }
        }
        
        if self.media != nil {
            if self.media!["type"] as! String == "image"{
                let imageUrl = self.media!["imageUrl"] as! String
                cardPrimaryImageURL = NSURL(string:imageUrl)
            }
        }
        
        self.primaryImageURL = cardPrimaryImageURL
        self.appLinkIos = cardAppLinkIos
        self.subtitle = subtitle
        
        super.init(webUrl: url, cardType: "summary")
    }
    
    override class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        var summaryCard:SummaryCard?
        var startURL:NSURL?
        var title:String?
        var description:String?
        
        if let urlString = data["webUrl"] as? String{
            startURL = NSURL(string:urlString)
        }
        
        if let summary = data["summary"] as? NSDictionary{
            title = summary["title"] as? String
            description = summary["description"] as? String
            if(title != nil && startURL != nil && description != nil){
                let media = summary["media"] as? NSDictionary
                summaryCard = SummaryCard(url: startURL!, description: description!, title: title!, media:media, data:data)
            }
        }
        return summaryCard
    }
    
    public override func supportsLayout(layout: WCCardLayout) -> Bool {
        return layout == WCCardLayout.SummaryCardTall ||
            layout == WCCardLayout.SummaryCardShort ||
            layout == WCCardLayout.SummaryCardShortLeft ||
            layout == WCCardLayout.SummaryCardNoImage ||
            layout == WCCardLayout.SummaryCardImageOnly ||
            layout == WCCardLayout.SummaryCardTwitterProfile ||
            layout == WCCardLayout.SummaryCardTwitterTweet
    }
}