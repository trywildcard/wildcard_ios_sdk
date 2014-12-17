//
//  Publisher.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/17/14.
//
//

import Foundation

public class Publisher : PlatformObject {
    
    public var domain:NSURL?
    public var name:String
    public var smallLogoUrl:NSURL?
    public var subcategories:[String]?
    public var description:String?
    public var twitterHandle:String?
    
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
            
            return publisher
        }else{
            return nil
        }
    }
}