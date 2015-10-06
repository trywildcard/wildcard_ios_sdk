//
//  ImageCache.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import Foundation
import NotificationCenter

class ImageCache: NSCache {
    
    // swift doesn't support class constant variables yet, but you can do it in a struct
    class var sharedInstance : ImageCache{
        struct Static{
            static var onceToken : dispatch_once_t = 0
            static var instance : ImageCache? = nil
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = ImageCache()
            NSNotificationCenter.defaultCenter().addObserver(
                Static.instance!,
                selector: "memoryWarningReceived",
                name: UIApplicationDidReceiveMemoryWarningNotification,
                object: nil)
        })
        return Static.instance!
    }
    
    func memoryWarningReceived(){
        ImageCache.sharedInstance.removeAllObjects()
    }
    
    class func cacheKeyFromRequest(request:NSURLRequest)->String{
        return request.URL!.absoluteString
    }
    
    func cachedImageForRequest(request:NSURLRequest)->UIImage?{
        switch request.cachePolicy{
        case NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
        NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData:
            return nil
        default:
            break
        }
        return objectForKey(ImageCache.cacheKeyFromRequest(request)) as? UIImage
    }
    
    func cacheImageForRequest(image:UIImage,request:NSURLRequest){
        setObject(image, forKey: ImageCache.cacheKeyFromRequest(request))
    }
}