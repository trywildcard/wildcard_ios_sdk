//
//  ArticleCard.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/3/14.
//
//

import Foundation

/*
 * Article Card
 *
 * Official Schema:
 * http://www.trywildcard.com/docs/schema/#article-card
 *
 */
@objc
public class ArticleCard : Card{
    
    let title:String
    let html:String
    
    let publicationDate:NSDate?
    let isBreaking:Bool?
    let abstractContent:String?
    let source:String?
    let author:String?
    let updatedDate:NSDate?
    let media:[NSDictionary]?
    let appLinkAndroid:NSURL?
    let appLinkIOS:NSURL?
    let primaryImageURL:NSURL?
    
    public init(title:String,html:String, url:NSURL, dictionary:NSDictionary?){
        self.title = title
        self.html = html
        super.init(webUrl: url, cardType: "article")
        
        abstractContent = dictionary?["description"] as? String
        
        if let epochTime = dictionary?["publishedAt"] as? NSTimeInterval{
            publicationDate = NSDate(timeIntervalSince1970: epochTime/1000)
        }
        
        if let epochTime = dictionary?["lastUpdatedAt"] as? NSTimeInterval{
            updatedDate = NSDate(timeIntervalSince1970: epochTime/1000)
        }
        
        author = dictionary?["author"] as? String
        source = dictionary?["source"] as? String
        isBreaking = dictionary?["breaking"] as? Bool
        media = dictionary?["media"] as? [NSDictionary]
        
        if media != nil && media?.count > 0{
            let mediaDictionary = media![0]
            if mediaDictionary["type"] as String == "image"{
                let src = mediaDictionary["src"] as String
                primaryImageURL = NSURL(string:src)
            }
        }
    }
    
    public class func createFromWebUrl(url:NSURL, completion: ((ArticleCard?, NSError?)->Void)) -> Void{
        Platform.getArticleCardFromWebUrl(url,completion:completion)
    }
    
}