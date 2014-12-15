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
public class ArticleCard : Card{
    
    var title:String
    var html:String
    
    var publicationDate:NSDate?
    var isBreaking:Bool?
    var abstractContent:String?
    var source:String?
    var author:String?
    var updatedDate:NSDate?
    var media:[NSDictionary]?
    var appLinkAndroid:NSURL?
    var appLinkIOS:NSURL?
    var primaryImageURL:NSURL?
    
    public init(title:String,html:String, url:NSURL){
        self.title = title
        self.html = html
        super.init(webUrl: url, cardType: "article")
    }
    
    override class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        var articleCard:ArticleCard?
        
        var startURL:NSURL?
        var title:String?
        var html:String?
        if let urlString = data["startUrl"] as? String{
            startURL = NSURL(string:urlString)
        }
        
        if let article = data["article"] as? NSDictionary{
            title = article["title"] as? String
            html = article["html"] as? String
            if(title != nil && html != nil && startURL != nil){
                articleCard = ArticleCard(title: title!, html: html!, url: startURL!)
                
                if let epochTime = article["publishedAt"] as? NSTimeInterval{
                    articleCard?.publicationDate = NSDate(timeIntervalSince1970: epochTime/1000)
                }
                
                if let epochTime = article["lastUpdatedAt"] as? NSTimeInterval{
                    articleCard?.updatedDate = NSDate(timeIntervalSince1970: epochTime/1000)
                }
                
                articleCard?.abstractContent = article["description"] as? String
                articleCard?.author = article["author"] as? String
                articleCard?.source = article["source"] as? String
                articleCard?.isBreaking = article["breaking"] as? Bool
                articleCard?.media = article["media"] as? [NSDictionary]
                
                if articleCard?.media != nil && articleCard?.media?.count > 0{
                    if let mediaDictionary = articleCard?.media![0]{
                        if mediaDictionary["type"] as String == "image"{
                            let src = mediaDictionary["src"] as String
                            articleCard?.primaryImageURL = NSURL(string:src)
                        }
                    }
                }
            }
        }
        return articleCard
    }
    
    
    // Attempts to create an Article Card from a web URL.
    public class func createFromWebUrl(url:NSURL, completion: ((ArticleCard?, NSError?)->Void)) -> Void{
        Platform.sharedInstance.getArticleCardFromWebUrl(url,completion:completion)
    }
    
    // Searches for article cards from a given query
    public class func searchArticleCards(query:String, completion: (([ArticleCard]?, NSError?)->Void)) -> Void{
        Platform.sharedInstance.generalSearchFromQuery(query, completion: { (results:[NSDictionary]?, error:NSError?) -> Void in
            if(error != nil){
                completion(nil,error)
            }else{
                var articleCards:[ArticleCard] = []
                if(results != nil){
                    for result in results!{
                        if let cardTypeDict = result["cardType"] as? NSDictionary{
                            if let type = cardTypeDict["name"] as? String{
                                if type == "article"{
                                    if let newArticle = ArticleCard.deserializeFromData(result) as? ArticleCard{
                                        articleCards.append(newArticle)
                                    }
                                }
                            }
                        }
                    }
                }
                completion(articleCards,nil)
            }
        })
    }
    
}