//
//  WCImageView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/26/15.
//
//

import Foundation

/// Wildcard Extension of UIImageView with a few extra functions
@objc
public class WCImageView : UIImageView
{
    
    public func setImageWithURL(url:NSURL, mode:UIViewContentMode){
        setImageWithURL(url, mode:mode, completion: nil)
    }
    
    public func setImageWithURL(url:NSURL, mode:UIViewContentMode, completion: ((UIImage?, NSError?)->Void)?) -> Void
    {
        backgroundColor = UIColor.wildcardBackgroundGray()
        let imageRequest = NSMutableURLRequest(URL: url)
        imageRequest.addValue("image/*", forHTTPHeaderField: "Accept")
        
        cancelRequest()
        
        if let cachedImage = ImageCache.sharedInstance.cachedImageForRequest(imageRequest){
            if let cb = completion{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cb(cachedImage,nil)
                })
            }else{
                image = cachedImage
                contentMode = mode
            }
        }else{
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: WildcardSDK.networkDelegateQueue)
            downloadTask =
            session.downloadTaskWithRequest(imageRequest,
                completionHandler: { (location:NSURL!, resp:NSURLResponse!, error:NSError!) -> Void in
                    //self.backgroundColor = UIColor.clearColor()
                    if(error == nil){
                        let data:NSData? = NSData(contentsOfURL: location)
                        if let newImage = UIImage(data: data!){
                            ImageCache.sharedInstance.cacheImageForRequest(newImage, request: imageRequest)
                            if let cb = completion{
                                cb(newImage,nil)
                            }else{
                                self.image = newImage
                                self.contentMode = mode
                            }
                        }else{
                            let error = NSError(domain: "Couldn't create image from data", code: 0, userInfo: nil)
                            if let cb = completion{
                                cb(nil,error)
                            }else{
                                self.setNoImage()
                            }
                        }
                    }else{
                        if let cb = completion{
                            cb(nil,error)
                        }else{
                            self.setNoImage()
                        }
                    }
            })
            downloadTask?.resume()
        }
    }
    
    /// Set the default place holder image, use this when there was a problem downloading or loading an image
    public func setNoImage(){
        backgroundColor = UIColor.wildcardBackgroundGray()
        self.image = UIImage.loadFrameworkImage("noImage")
        self.tintColor = UIColor.whiteColor()
        self.contentMode = .Center
    }
    
    
    private var downloadTask:NSURLSessionDownloadTask?
    
    /// cancel any pending image requests
    public func cancelRequest(){
        downloadTask?.cancel()
        downloadTask = nil;
    }
    
}