//
//  LinkCard.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/4/14.
//
//

import Foundation

/*
* Link Card
*
* Official Schema:
* http://www.trywildcard.com/docs/schema/#link-card
*
*/
@objc
public class LinkCard : Card{
    
    let title:String
    let description:String
    
    let imageUrl:NSURL?
    
    init(url:NSURL, description:String, title:String,dictionary:NSDictionary){
        self.title = title
        self.description = description
        super.init(webUrl: url, cardType: "link")
        
        if let imageUrl = dictionary["primaryImageUrl"] as? String{
            self.imageUrl = NSURL(string: imageUrl)
        }
    }
    
    public class func createFromWebUrl(url:NSURL, completion: ((LinkCard?, NSError?)->Void)) -> Void{
        Platform.getLinkCardFromWebUrl(url,completion:completion)
    }
    
}