//
//  Platform.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/4/14.
//
//

import Foundation

protocol PlatformObject{
    class func deserializeFromData(data:NSDictionary) -> AnyObject?
}

/*
* Platform
*
* Any interaction we have with the Wildcard Platform should go here
*/
class Platform{
    
    let platformBaseURL = "http://platform-prod.trywildcard.com"
    
    // swift doesn't support class constant variables yet, but you can do it in a struct
    class var sharedInstance : Platform{
        struct Static{
            static var instance : Platform = Platform()
        }
        return Static.instance
    }
    
    func createWildcardShortLink(url:NSURL, completion:((NSURL?,NSError?)->Void)) ->Void
    {
        var targetUrlEncoded = url.absoluteString!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlString = Platform.sharedInstance.platformBaseURL + "/v1.0/shortlink?url=" + targetUrlEncoded!
        let shortLinkPlatformUrl = NSURL(string:urlString)!
        getJsonResponseFromWebUrl(shortLinkPlatformUrl) { (json:NSDictionary?, error:NSError?) -> Void in
            if(error == nil){
                if(json != nil){
                    if let shortLink = json!["short_link_result"] as? String{
                        completion(NSURL(string: shortLink),nil)
                    }else{
                        completion(nil,NSError())
                    }
                }else{
                    completion(nil,NSError())
                }
            }else{
                completion(nil,error)
            }
        }
    }
    
    private func getJsonResponseFromWebUrl(url:NSURL, completion:((NSDictionary?, NSError?)->Void)) -> Void
    {
        var session = NSURLSession.sharedSession()
        
        var task:NSURLSessionTask = session.dataTaskWithURL(url, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if(error != nil){
                completion(nil, error)
            }else{
                var jsonError:NSError?
                var json:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
                if (jsonError != nil) {
                    completion(nil, jsonError)
                }
                else {
                    completion(json, nil)
                }
            }
        })
        task.resume()
    }
    
    func generalSearchFromQuery(query:String, limit:Int, type:String, completion: (([Card]?, NSError?)->Void)) -> Void
    {
        var queryParam = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var urlString = Platform.sharedInstance.platformBaseURL +
        "/v2.1/cross_brand_search?limit=\(limit)&q=\(queryParam)&cardTypeName=\(type)"
        
        let platformUrl = NSURL(string:urlString)!
        getJsonResponseFromWebUrl(platformUrl) { (json:NSDictionary?, error:NSError?) -> Void in
            if(error == nil){
                var results:[Card] = []
                if let result = json!["result"] as? NSArray{
                    for item in result{
                        if let data = item as? NSDictionary{
                            if let newCard = Card.deserializeFromData(data) as? Card{
                                results.append(newCard)
                            }
                        }
                    }
                }
                completion(results,nil)
            }else{
                completion(nil,error)
            }
        }
    }
    
    func getArticleCardFromWebUrl(url:NSURL, completion: ((ArticleCard?, NSError?)->Void)) -> Void
    {
        var targetUrlEncoded = url.absoluteString!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlString = Platform.sharedInstance.platformBaseURL + "/v1.0/create_article_card?url=" + targetUrlEncoded!
        let platformUrl = NSURL(string:urlString)
        
        self.getJsonResponseFromWebUrl(platformUrl!, completion: { (json:NSDictionary?, error: NSError?) -> Void in
            if(error == nil){
                var articleCard:ArticleCard?
                if let result = json!["result"] as? NSArray{
                    if result.count > 0 && result[0] is NSDictionary{
                        if let newArticle = ArticleCard.deserializeFromData(result[0] as NSDictionary) as? ArticleCard{
                            articleCard = newArticle
                        }
                    }
                }
                completion(articleCard, nil)
            }else{
                completion(nil,error)
            }
        })
    }
    
    func getWebLinkCardFromWebUrl(url:NSURL, completion: ((WebLinkCard?, NSError?)->Void)) -> Void
    {
        var targetUrlEncoded = url.absoluteString!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlString = Platform.sharedInstance.platformBaseURL + "/v1.0/extractmetatags/cardpress/?url=" + targetUrlEncoded!
        let requestURL = NSURL(string:urlString)
        
        var session = NSURLSession.sharedSession()
        var task:NSURLSessionTask = session.dataTaskWithURL(requestURL!, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if(error != nil){
                completion(nil, error)
            }else{
                var jsonError:NSError?
                var json:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
                if (jsonError != nil) {
                    completion(nil, jsonError)
                }
                else {
                    var linkCard:WebLinkCard?
                    if let result = json!["result"] as? NSDictionary{
                        let title = result["title"] as? String
                        let description = result["description"] as? String
                        if title != nil && description != nil{
                            linkCard = WebLinkCard(url: url,description:description!, title: title!, dictionary: result)
                        }
                    }
                    completion(linkCard, nil)
                }
            }
        })
        task.resume()
        
    }
    
}