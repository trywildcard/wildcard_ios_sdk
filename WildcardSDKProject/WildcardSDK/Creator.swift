//
//  Publisher.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/17/14.
//
//

import Foundation

/**
Creator of a Card

Any entity that owns Card content. This may be a company, specific website, or individual.
*/
@objc
public class Creator : PlatformObject {
    
    public let name:String
    public let url:NSURL
    public let favicon:NSURL?
    public let iosAppStoreUrl:NSURL?
    public let androidAppStoreUrl:NSURL?
    
    public init(name:String, url:NSURL, favicon:NSURL?, iosStore:NSURL?, androidStore:NSURL?){
        self.name = name
        self.url = url
        self.favicon = favicon
        self.iosAppStoreUrl = iosStore
        self.androidAppStoreUrl = androidStore
    }
    
    class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        
        let name = data["name"] as? String
        var creatorUrl:NSURL?
        if let url = data["url"] as? String{
            creatorUrl = NSURL(string: url)
        }
        
        if(name != nil && creatorUrl != nil){
            var favicon:NSURL?
            var iosStoreUrl:NSURL?
            var androidStoreUrl:NSURL?
            
            if let fav = data["favicon"] as? String{
                favicon = NSURL(string: fav)
            }
            
            if let androidStore = data["androidAppStoreUrl"] as? String{
                androidStoreUrl = NSURL(string:androidStore)
            }
            
            if let iosStore = data["iosAppStoreUrl"] as? String{
                iosStoreUrl = NSURL(string:iosStore)
            }
            
            return Creator(name:name!, url:creatorUrl!, favicon:favicon, iosStore:iosStoreUrl, androidStore:androidStoreUrl)
        }else{
            return nil
        }
    }
    
    class func publisherTypeFromString(type:String) -> WCPublisherType{
        if(type == "Commerce"){
            return .Commerce
        }else if(type == "Content"){
            return .Content
        }else{
            return .Unknown
        }
    }
    
}