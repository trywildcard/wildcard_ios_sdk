//
//  Card.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/3/14.
//
//

import Foundation

@objc
public class Card : PlatformObject {
    
    public let webUrl:NSURL
    public let cardType:String
    public let type:CardType
    
    init(webUrl:NSURL, cardType:String){
        self.webUrl = webUrl
        self.cardType = cardType
        self.type = Card.cardTypeFromString(cardType)
    }
    
    public class func cardTypeFromString(name:String) -> CardType{
        if(name == "article"){
            return CardType.WCCardTypeArticle
        }else if(name == "summary"){
            return CardType.WCCardTypeSummary
        }else{
            return CardType.WCCardTypeUnknown
        }
    }
    
    public class func stringFromCardType(type:CardType)->String{
        switch(type){
        case .WCCardTypeArticle:
            return "article"
        case .WCCardTypeSummary:
            return "summary"
        case .WCCardTypeUnknown:
            return "unknown"
        }
    }
    
    class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        if let cardTypeDict = data["cardType"] as? NSDictionary{
            if let cardTypeValue = cardTypeDict["name"] as? String{
                switch(cardTypeValue){
                case "article":
                    return ArticleCard.deserializeFromData(data) as? ArticleCard
                default:
                    return nil
                }
            }
        }
        return nil
    }
}