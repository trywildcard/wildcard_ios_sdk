//
//  VideoCardBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/9/15.
//
//

import Foundation
import WebKit

@objc
public class VideoCardBody : CardViewElement, WKNavigationDelegate, UIGestureRecognizerDelegate {
    
    public var videoWKView:WKWebView!
    public var spinner:UIActivityIndicatorView!
    
    /// Adjusts the aspect ratio of the video
    public var videoAspectRatio:CGFloat{
        get{
            return __videoAspectRatio
        }
        set{
            __videoAspectRatio = newValue
            videoHeightConstraint.constant = round(videoWidthConstraint.constant * __videoAspectRatio)
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Content insets
    public var contentEdgeInset:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(topConstraint.constant, leftConstraint.constant, bottomConstraint.constant, rightConstraint.constant)
        }
        set{
            topConstraint.constant = newValue.top
            leftConstraint.constant = newValue.left
            rightConstraint.constant = newValue.right
            bottomConstraint.constant = newValue.bottom
            
            //needs re adjust if content insets change
            adjustForPreferredWidth(preferredWidth)
        }
    }
    
    private var topConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    private var rightConstraint:NSLayoutConstraint!
    private var bottomConstraint:NSLayoutConstraint!
    private var videoHeightConstraint:NSLayoutConstraint!
    private var videoWidthConstraint:NSLayoutConstraint!
    private var __videoAspectRatio:CGFloat = 0.75
    private var posterView:WCImageView!
    private var tapGestureRecognizer:UITapGestureRecognizer!
    private var videoPlaying:Bool = false
   
    override public func initialize(){
        
        // initializes the video wkwebview
        var configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = false
        configuration.mediaPlaybackRequiresUserAction = true
        videoWKView = WKWebView(frame: CGRectZero, configuration: configuration)
        videoWKView.layer.cornerRadius = WildcardSDK.imageCornerRadius
        videoWKView.layer.masksToBounds = true
        videoWKView.backgroundColor = UIColor.blackColor()
        videoWKView.scrollView.scrollEnabled = false
        videoWKView.scrollView.bounces = false
        videoWKView.navigationDelegate = self
        videoWKView.userInteractionEnabled = true
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "videoTapped:");
        tapGestureRecognizer.delegate = self
        videoWKView.addGestureRecognizer(tapGestureRecognizer)
        
        // wkbview constraints
        addSubview(videoWKView)
        leftConstraint = videoWKView.constrainLeftToSuperView(10)
        rightConstraint = videoWKView.constrainRightToSuperView(10)
        topConstraint = videoWKView.constrainTopToSuperView(10)
        bottomConstraint = videoWKView.constrainBottomToSuperView(10)
        videoWidthConstraint = videoWKView.constrainWidth(0)
        videoWidthConstraint.priority = 999
        videoHeightConstraint = videoWKView.constrainHeight(0)
        videoHeightConstraint.priority = 999
        
        // spinner, always centered on the web view
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner.hidesWhenStopped = true
        spinner.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(spinner)
        addConstraint(NSLayoutConstraint(item: spinner, attribute: .CenterX, relatedBy: .Equal, toItem: videoWKView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: spinner, attribute: .CenterY, relatedBy: .Equal, toItem: videoWKView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        // observers when video is tapped
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoExitFullScreen:", name: UIWindowDidBecomeHiddenNotification, object: self.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoEnterFullScreen:", name: UIWindowDidBecomeVisibleNotification, object: self.window)
    }
    
    public override func adjustForPreferredWidth(cardWidth: CGFloat) {
        videoWidthConstraint.constant = cardWidth - leftConstraint.constant - rightConstraint.constant
        videoHeightConstraint.constant = round(videoWidthConstraint.constant * __videoAspectRatio)
        invalidateIntrinsicContentSize()
    }
    
    override public func update(card:Card) {
        if let videoCard = card as? VideoCard{
            let request = NSURLRequest(URL: videoCard.embedUrl)
            videoWKView.loadRequest(request)
        }else{
            println("VideoCardBody element should only be used with a video card.")
        }
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        height += topConstraint.constant
        height += videoHeightConstraint.constant
        height += bottomConstraint.constant
        return height
    }
    
    // MARK: UIGestureRecognizerDelegate
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        if(gestureRecognizer == tapGestureRecognizer || otherGestureRecognizer == tapGestureRecognizer){
            // we want our tap gesture to be recognized alongside the WKWebView's default one
            return true;
        }else{
            return false;
        }
    }
    
    // MARK: Action
    func videoTapped(recognizer:UITapGestureRecognizer!){
        WildcardSDK.analytics?.trackEvent("CardEngagement", withProperties: ["cta":"videoTapped"], withCard:cardView?.backingCard)
        videoPlaying = true
    }
    
    func videoEnterFullScreen(notification:NSNotification!){
        if(videoPlaying){
            if(cardView != nil){
                cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoStartedPlaying, parameters: nil))
            }
        }
    }
    
    func videoExitFullScreen(notification:NSNotification!){
        if(videoPlaying){
            if(cardView != nil){
                cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoStoppedPlaying, parameters: nil))
            }
            videoPlaying = false
        }
    }
    
    // MARK: WKNavigationDelegate
    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!){
        spinner.startAnimating()
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        spinner.stopAnimating()
    }
}
