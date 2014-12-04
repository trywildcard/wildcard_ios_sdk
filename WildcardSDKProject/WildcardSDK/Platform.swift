//
//  Platform.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/4/14.
//
//

import Foundation

class Platform{
    
    // swift doesn't support class constant variables yet, but you can do it in a struct
    class var sharedInstance : Platform{
        struct Static{
            static var instance : Platform = Platform()
        }
        return Static.instance
    }
    
    class var platformBaseURL:String{
        return "http://platform-prod.trywildcard.com"
    }
    
    class func getArticleCardFromWebUrl(url:NSURL, completion: ((ArticleCard?, NSError?)->Void)) -> Void
    {
        var targetUrlEncoded = url.absoluteString!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlString = Platform.platformBaseURL + "/v1.0/create_article_card?url=" + targetUrlEncoded!
        let url = NSURL(string:urlString)
        
        var session = NSURLSession.sharedSession()
        var task:NSURLSessionTask = session.dataTaskWithURL(url!, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if(error != nil){
                completion(nil, error)
            }else{
                var jsonError:NSError?
                var json:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
                if (jsonError != nil) {
                    completion(nil, jsonError)
                }
                else {
                    var articleCard:ArticleCard?
                    if let result = json!["result"] as? NSArray{
                        if result.count > 0 && result[0] is NSDictionary{
                            let resultDict = result[0] as NSDictionary
                            var startURL:NSURL?
                            var title:String?
                            var html:String?
                            if let urlString = resultDict["startUrl"] as? String{
                                startURL = NSURL(string:urlString)
                            }
                            
                            if let article = resultDict["article"] as? NSDictionary{
                                title = article["title"] as? String
                                html = article["html"] as? String
                                
                                if(title != nil && html != nil && startURL != nil){
                                    articleCard  = ArticleCard(title: title!, html: html!, url: startURL!, dictionary:article)
                                }
                            }
                        }
                        
                    }
                    completion(articleCard, nil)
                }
            }
        })
        task.resume()
        
    }
    
}