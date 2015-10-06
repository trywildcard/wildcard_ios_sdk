//
//  NSURLExtensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/23/15.
//
//

import Foundation

public extension NSURL{
    
    func isTwitterProfileURL()->Bool{
        let length:Int = absoluteString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if (length > 0) {
            let pattern = "^http(s)://(www.)?twitter.com/(\\w*)\\/?$"
            let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let length:Int = absoluteString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            let ytMatch = regex?.firstMatchInString(absoluteString, options: NSMatchingOptions(), range: NSMakeRange(0, length))
            if(ytMatch != nil){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func isTwitterTweetURL()->Bool{
        let length:Int = absoluteString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if (length > 0) {
            let pattern = "^http(s)://(www.)?twitter.com/(\\w*)/status/(\\d*)\\/?$"
            let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let ytMatch = regex?.firstMatchInString(absoluteString, options: NSMatchingOptions(), range: NSMakeRange(0, length))
            if(ytMatch != nil){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
}