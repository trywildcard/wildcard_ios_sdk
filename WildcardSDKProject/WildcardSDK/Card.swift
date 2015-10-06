//
//  Card.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/3/14.
//
//

import Foundation

/// Card base class
@objc
public class Card : NSObject, PlatformObject {
    
    /// Associated web url for this card
    public let webUrl:NSURL
    
    public let cardType:String
    public let type:WCCardType
    
    init(webUrl:NSURL, cardType:String){
        self.webUrl = webUrl
        self.cardType = cardType
        self.type = Card.cardTypeFromString(cardType)
    }
    
    public class func cardTypeFromString(name:String!) -> WCCardType{
        if let name = name{
            if(name == "article"){
                return .Article
            }else if(name == "summary"){
                return .Summary
            }else if(name == "video"){
                return .Video
            }else if(name == "image"){
                return .Image
            }else{
                return .Unknown
            }
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
        case .Video:
            return "video"
        case .Image:
            return "image"
        case .Unknown:
            return "unknown"
        }
    }

    /// Gets a card from the specified URL
    public class func getFromUrl(url:NSURL!, completion: ((card:Card?, error:NSError?)->Void)?) -> Void{
        if let url = url{
            Platform.sharedInstance.getFromUrl(url, completion:completion)
        }else{
            print("getFromUrl() failed, url is nil.")
        }
    }
    
    class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        if let cardType = data["cardType"] as? String{
            switch(cardType){
            case "article":
                return ArticleCard.deserializeFromData(data) as? ArticleCard
            case "summary":
                return SummaryCard.deserializeFromData(data) as? SummaryCard
            case "video":
                return VideoCard.deserializeFromData(data) as? VideoCard
            case "image":
                return ImageCard.deserializeFromData(data) as? ImageCard
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