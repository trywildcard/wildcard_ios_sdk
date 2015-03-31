//
//  WCImageView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/26/15.
//
//

import Foundation
import QuartzCore

@objc
public protocol WCImageViewDelegate{
    optional func imageViewTapped(imageView:WCImageView)
}

/// Wildcard Extension of UIImageView with a few extra functions
@objc
public class WCImageView : UIImageView
{
    /// Default cross fade animation duration when setting an image
    public var crossFadeDuration:NSTimeInterval = 0.3
    
    /// Set image to URL and automatically set the image
    public func setImageWithURL(url:NSURL, mode:UIViewContentMode){
        setImageWithURL(url, mode:mode, completion: nil)
    }
    
    /// See WCImageViewDelegate
    public var delegate:WCImageViewDelegate?
    
    /// Set image to URL with a completion block. This does not automatically set the image -- more suitable for re-use scenarios
    public func setImageWithURL(url:NSURL, mode:UIViewContentMode, completion: ((UIImage?, NSError?)->Void)?) -> Void
    {
        let imageRequest = NSMutableURLRequest(URL: url)
        imageRequest.addValue("image/*", forHTTPHeaderField: "Accept")
        
        cancelRequest()
        
        if let cachedImage = ImageCache.sharedInstance.cachedImageForRequest(imageRequest){
            if let cb = completion{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cb(cachedImage,nil)
                })
            }else{
                setImage(cachedImage, mode: mode)
            }
        }else{
            startPulsing()
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: WildcardSDK.networkDelegateQueue)
            _downloadTask =
                session.downloadTaskWithRequest(imageRequest,
                    completionHandler: { (location:NSURL!, resp:NSURLResponse!, error:NSError!) -> Void in
                        self.stopPulsing()
                        
                        if(error == nil){
                            let data:NSData? = NSData(contentsOfURL: location)
                            if let newImage = UIImage(data: data!){
                                ImageCache.sharedInstance.cacheImageForRequest(newImage, request: imageRequest)
                                if let cb = completion{
                                    cb(newImage,nil)
                                }else{
                                    self.setImage(newImage, mode: mode)
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
            _downloadTask?.resume()
        }
    }
    
    /// Set the default place holder image, use this when there was a problem downloading or loading an image
    public func setNoImage(){
        tintColor = UIColor.whiteColor()
        setImage(UIImage.loadFrameworkImage("noImage")!, mode: .Center)
    }
    
    /// Cancel any pending image requests
    public func cancelRequest(){
        _downloadTask?.cancel()
        _downloadTask = nil;
    }
    
    /// Set image with a content mode. Does a cross fade animation by default
    public func setImage(image:UIImage, mode:UIViewContentMode){
        contentMode = mode
        UIView.transitionWithView(self,
            duration:crossFadeDuration,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { self.image = image },
            completion: nil)
    }
    
    private var _downloadTask:NSURLSessionDownloadTask?
    private var _tapGesture:UITapGestureRecognizer!
    
    private func startPulsing(){
        var pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 0.75
        pulseAnimation.toValue = NSNumber(float: 1.0)
        pulseAnimation.fromValue = NSNumber(float: 0.5)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        pulseAnimation.autoreverses = true;
        pulseAnimation.repeatCount = FLT_MAX;
        layer.addAnimation(pulseAnimation, forKey: nil)
    }

    private func stopPulsing(){
        layer.removeAllAnimations()
    }
    
    func imageViewTapped(recognizer:UITapGestureRecognizer!){
        delegate?.imageViewTapped?(self)
    }
    
    public func setup(){
        backgroundColor = UIColor.wildcardBackgroundGray()
        layer.cornerRadius = WildcardSDK.imageCornerRadius
        layer.masksToBounds = true
        userInteractionEnabled = true
        
        _tapGesture = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
        addGestureRecognizer(_tapGesture)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    public override init(){
        super.init()
        setup()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}