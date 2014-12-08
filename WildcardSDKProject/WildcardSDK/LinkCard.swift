//
//  LinkCard.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/4/14.
//
//

import Foundation

/*
* WebLink Card
*
* Official Schema:
* http://www.trywildcard.com/docs/schema/#link-card
*
*/
@objc
public class WebLinkCard : Card{
    
    let title:String
    let description:String
    
    let imageUrl:NSURL?
    
    public init(url:NSURL, description:String, title:String,dictionary:NSDictionary?){
        self.title = title
        self.description = description
        super.init(webUrl: url, cardType: "weblink")
        
        if let imageUrl = dictionary?["primaryImageUrl"] as? String{
            self.imageUrl = NSURL(string: imageUrl)
        }
    }
    
    public class func createFromWebUrl(url:NSURL, completion: ((WebLinkCard?, NSError?)->Void)) -> Void{
        Platform.getWebLinkCardFromWebUrl(url,completion:completion)
    }
    
}