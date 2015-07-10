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
        if(absoluteString != nil){
            let pattern = "^http(s)://(www.)?twitter.com/(\\w*)\\/?$"
            let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            let length:Int = absoluteString!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            let ytMatch = regex?.firstMatchInString(absoluteString!, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, length))
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
        if(absoluteString != nil){
            let pattern = "^http(s)://(www.)?twitter.com/(\\w*)/status/(\\d*)\\/?$"
            let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            let length:Int = absoluteString!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            let ytMatch = regex?.firstMatchInString(absoluteString!, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, length))
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