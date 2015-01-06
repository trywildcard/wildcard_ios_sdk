//
//  Publisher.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/17/14.
//
//

import Foundation

/**
    Publisher of a Card

    Any entity that owns Card content. This may be a company, specific website, or individual.
*/
public class Publisher : PlatformObject {
    
    public enum Type{
        case Unknown
        case Content
        case Commerce
    }
    
    public var name:String
    public var domain:NSURL?
    public var smallLogoUrl:NSURL?
    public var subcategories:[String]?
    public var description:String?
    public var twitterHandle:String?
    public var pinterestHandle:String?
    public var type:Type = .Unknown
    public var appStoreIconUrl:NSURL?
    public var appStoreUrl:NSURL?
    
    public init(name:String){
        self.name = name
    }
    
    class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        if let name = data["name"] as? String{
            let publisher = Publisher(name:name)
            if let domains = data["domains"] as? NSArray{
                if domains.count > 0{
                    publisher.domain = NSURL(string: domains[0] as String)
                }
            }
            
            if let smallLogoUrlString = data["logoURL"] as? String{
                publisher.smallLogoUrl = NSURL(string: smallLogoUrlString)
            }
            if let subcategories = data["subcategories"] as? [String]{
                publisher.subcategories = subcategories
            }
            if let description = data["description"] as? String{
                publisher.description = description
            }
            if let twitterHandle = data["twitterHandle"] as? String{
                publisher.twitterHandle = twitterHandle
            }
            if let pinterestHandle = data["pinterestHandle"] as? String{
                publisher.twitterHandle = pinterestHandle
            }
            if let appStoreIconUrl = data["appStoreIcon"] as? String{
                publisher.appStoreIconUrl = NSURL(string: appStoreIconUrl)
            }
            if let appStoreUrl = data["appStoreLink"] as? String{
                publisher.appStoreUrl = NSURL(string: appStoreUrl)
            }
            if let type = data["brandType"] as? String{
                publisher.type = Publisher.publisherTypeFromString(type)
            }
            
            return publisher
        }else{
            return nil
        }
    }
    
    class func publisherTypeFromString(type:String) -> Type{
        if(type == "Commerce"){
            return .Commerce
        }else if(type == "Content"){
            return .Content
        }else{
            return .Unknown
        }
    }
}