//
//  Card.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/3/14.
//
//

import Foundation

@objc
public class Card : NSObject, PlatformObject {
    
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

    /// Gets a card from the specified URL
    public class func getFromUrl(url:NSURL, completion: ((card:Card?, completion:NSError?)->Void)) -> Void{
        Platform.sharedInstance.getFromUrl(url, completion:completion)
    }
    
    class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        if let cardType = data["cardType"] as? String{
            switch(cardType){
            case "article":
                return ArticleCard.deserializeFromData(data) as? ArticleCard
            case "summary":
                return SummaryCard.deserializeFromData(data) as? SummaryCard
            default:
                return nil
            }
        }
        return nil
    }
    
    public func supportsLayout(layout:WCCardLayout)->Bool{
        return false;
    }
    
    
}