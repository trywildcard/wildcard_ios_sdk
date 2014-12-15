//
//  Card.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/3/14.
//
//

import Foundation

public class Card : PlatformObject{
    
    enum Type{
        case Unknown
        case Article
        case WebLink
    }
    
    let webUrl:NSURL
    let cardType:String
    let type:Type
    
    init(webUrl:NSURL, cardType:String){
        self.webUrl = webUrl
        self.cardType = cardType
        self.type = Card.cardTypeFromString(cardType)
    }
    
    class func cardTypeFromString(name:String) -> Type{
        if(name == "article"){
            return Type.Article
        }else if(name == "weblink"){
            return Type.WebLink
        }else{
            return Type.Unknown
        }
    }
    
    class func stringFromCardType(type:Type)->String{
        switch(type){
        case .Article:
            return "article"
        case .WebLink:
            return "weblink"
        default:
            return "unknown"
        }
    }
    
    class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        if let cardTypeDict = data["cardType"] as? NSDictionary{
            if let cardTypeValue = cardTypeDict["name"] as? String{
                switch(cardTypeValue){
                case "article":
                    return ArticleCard.deserializeFromData(data) as? ArticleCard
                case "weblink":
                    return WebLinkCard.deserializeFromData(data) as? WebLinkCard
                default:
                    return nil
                }
            }
        }
        return nil
    }
}