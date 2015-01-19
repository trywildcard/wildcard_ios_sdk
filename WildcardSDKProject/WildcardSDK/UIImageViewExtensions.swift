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
        let imageRequest = NSMutableURLRequest(URL: url)
        imageRequest.addValue("image/*", forHTTPHeaderField: "Accept")
        
        if let cachedImage = ImageCache.sharedInstance.cachedImageForRequest(imageRequest){
            completion(cachedImage,nil)
        }else{
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
            var downloadTask:NSURLSessionDownloadTask =
            session.downloadTaskWithRequest(imageRequest,
                completionHandler: { (location:NSURL!, resp:NSURLResponse!, error:NSError!) -> Void in
                    if(error == nil){
                        let data:NSData? = NSData(contentsOfURL: location)
                        if let newImage = UIImage(data: data!, scale: scale){
                            ImageCache.sharedInstance.cacheImageForRequest(newImage, request: imageRequest)
                            completion(newImage,nil)
                        }else{
                            let error = NSError(domain: "Couldn't create image from data", code: 0, userInfo: nil)
                            completion(nil,error)
                        }
                    }else{
                        completion(nil,error)
                    }
            })
            downloadTask.resume()
        }
    }
}