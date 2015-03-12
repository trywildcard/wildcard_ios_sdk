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
    private var videoTapped:Bool = false
    private var videoActionButton:UIButton!
    private var passthroughView:PassthroughView!
    private var videoActionImage:UIImageView!
    private var tintOverlay:UIView!
   
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
        
        // wkwebview constraints
        addSubview(videoWKView)
        leftConstraint = videoWKView.constrainLeftToSuperView(10)
        rightConstraint = videoWKView.constrainRightToSuperView(10)
        topConstraint = videoWKView.constrainTopToSuperView(10)
        bottomConstraint = videoWKView.constrainBottomToSuperView(10)
        videoWidthConstraint = videoWKView.constrainWidth(0)
        videoWidthConstraint.priority = 999
        videoHeightConstraint = videoWKView.constrainHeight(0)
        videoHeightConstraint.priority = 999
        
        // pass through view on top of webview for a poster image
        passthroughView = PassthroughView(frame:CGRectZero)
        insertSubview(passthroughView, aboveSubview: videoWKView)
        passthroughView.constrainExactlyToView(videoWKView)
        passthroughView.backgroundColor = UIColor.blackColor()
        
        posterView = WCImageView(frame:CGRectZero)
        posterView.clipsToBounds = true
        passthroughView.addSubview(posterView)
        posterView.constrainToSuperViewEdges()
        posterView.backgroundColor = UIColor.blackColor()
        
        // black tint overlay on the poster image
        tintOverlay = PassthroughView(frame:CGRectZero)
        tintOverlay.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        passthroughView.addSubview(tintOverlay)
        tintOverlay.constrainToSuperViewEdges()
        
        videoActionImage = UIImageView(frame:CGRectZero)
        videoActionImage.tintColor = UIColor.whiteColor()
        videoActionImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        videoActionImage.image = UIImage.loadFrameworkImage("playIcon")
        videoActionImage.hidden = true
        passthroughView.insertSubview(videoActionImage, aboveSubview: posterView)
        passthroughView.addSubview(videoActionImage)
        addConstraint(NSLayoutConstraint(item: videoActionImage, attribute: .CenterX, relatedBy: .Equal, toItem: passthroughView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: videoActionImage, attribute: .CenterY, relatedBy: .Equal, toItem: passthroughView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
        spinner.hidesWhenStopped = true
        spinner.setTranslatesAutoresizingMaskIntoConstraints(false)
        insertSubview(spinner, aboveSubview: passthroughView)
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
            
            if let posterImageUrl = videoCard.posterImageUrl {
                passthroughView.hidden = false
                posterView.image = nil;
                posterView.setImageWithURL(posterImageUrl, mode: .ScaleAspectFill, completion: { (image, error) -> Void in
                    
                    // if webview is done loading, stop the spinner
                    if(!self.videoWKView.loading){
                        self.spinner.stopAnimating()
                    }
                    
                    if(image != nil && error == nil){
                        self.posterView.image = image
                        self.posterView.contentMode = .ScaleAspectFill
                        
                        if(!self.videoWKView.loading){
                            self.videoActionImage.hidden = false
                        }
                    }else{
                        // error downloading poster image, hide it to just show web view
                       // self.passthroughView.hidden = true
                        self.posterView.setNoImage()
                    }
                })
                
            }else{
                // there isn't a poster image, hiding this just shows the webview
                passthroughView.hidden = true
            }
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
        // our custom gesture recognizer on the wkwebview just to capture this engagement and flag
        WildcardSDK.analytics?.trackEvent("CardEngagement", withProperties: ["cta":"videoTapped"], withCard:cardView?.backingCard)
        videoTapped = true
        
        passthroughView.hidden = true
    }
    
    func videoEnterFullScreen(notification:NSNotification!){
        if(videoTapped){
            if(cardView != nil){
                cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoStartedPlaying, parameters: nil))
            }
        }
    }
    
    func videoExitFullScreen(notification:NSNotification!){
        if(videoTapped){
            if(cardView != nil){
                cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoStoppedPlaying, parameters: nil))
            }
            videoTapped = false
        }
    }
    
    // MARK: WKNavigationDelegate
    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!){
        spinner.startAnimating()
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        if(passthroughView.hidden){
            spinner.stopAnimating()
        }else{
            if(posterView.image != nil){
                self.videoActionImage.hidden = false
                spinner.stopAnimating()
            }
        }
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        setError()
    }
    
    public func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        setError()
    }
    
    // MARK: Private
    private func setError(){
        passthroughView.hidden = false
        spinner.stopAnimating()
        posterView.cancelRequest()
        posterView.image = nil
        videoActionImage.hidden = false
        videoActionImage.image = UIImage(named: "noVideoFound")
    }

}
