//
//  UIImageViewExtensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/11/14.
//
//

import Foundation
import UIKit

extension UIImageView{
    
    func downloadImageWithURL(url:NSURL, scale:CGFloat, completion: ((UIImage?, NSError?)->Void)) -> Void
    {
        let imageRequest = NSURLRequest(URL: url)
        if let cachedImage = ImageCache.sharedInstance.cachedImageForRequest(imageRequest){
            completion(cachedImage,nil)
        }else{
            var downloadTask:NSURLSessionDownloadTask =
            NSURLSession.sharedSession().downloadTaskWithRequest(imageRequest,
                completionHandler: { (location:NSURL!, resp:NSURLResponse!, error:NSError!) -> Void in
                    if(error == nil){
                        let data:NSData? = NSData(contentsOfURL: location)
                        if let newImage = UIImage(data: data!, scale: scale){
                            ImageCache.sharedInstance.cacheImageForRequest(newImage, request: imageRequest)
                            dispatch_async(dispatch_get_main_queue(), {
                                completion(newImage,nil)
                            })
                        }else{
                            let error = NSError(domain: "Couldn't create image from data", code: 0, userInfo: nil)
                            dispatch_async(dispatch_get_main_queue(), {
                                completion(nil,error)
                            })
                        }
                    }else{
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(nil,error)
                        })
                    }
            })
            downloadTask.resume()
        }
    }
}