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
    public let type:WCCardType
    
    init(webUrl:NSURL, cardType:String){
        self.webUrl = webUrl
        self.cardType = cardType
        self.type = Card.cardTypeFromString(cardType)
    }
    
    public class func cardTypeFromString(name:String) -> WCCardType{
        if(name == "article"){
            return .Article
        }else if(name == "summary"){
            return .Summary
        }else{
            return .Unknown
        }
    }
    
    public class func stringFromCardType(type:WCCardType)->String{
        switch(type){
        case .Article:
            return "article"
        case .Summary:
            return "summary"
        case .Unknown:
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