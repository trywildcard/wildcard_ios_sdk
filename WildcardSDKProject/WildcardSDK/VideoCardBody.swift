//
//  VideoCardBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/9/15.
//
//

import Foundation
import MediaPlayer
import WebKit

/// A Card Body which can play various Video Cards
@objc
public class VideoCardBody : CardViewElement, WKNavigationDelegate, UIGestureRecognizerDelegate, WKScriptMessageHandler, YTPlayerViewDelegate {
    
    /// General web view to play most videos
    public var videoWKView:WKWebView!
    
    /// Youtube videos use: https://github.com/youtube/youtube-ios-player-helper
    public var ytPlayer:YTPlayerView!
    
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
    private var ytTapGestureRecognizer:UITapGestureRecognizer!
    private var videoActionButton:UIButton!
    private var passthroughView:PassthroughView!
    private var videoActionImage:UIImageView!
    private var tintOverlay:UIView!
    private var spinner:UIActivityIndicatorView!
    private var moviePlayer:MPMoviePlayerViewController?
    private var streamUrl:NSURL?
   
    override public func initialize(){
        
        // initializes the video wkwebview
        let controller = WKUserContentController()
        controller.addScriptMessageHandler(self, name: "observe")
        var configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = false
        configuration.mediaPlaybackRequiresUserAction = true
        configuration.userContentController = controller
        
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
        
        // youtube has its own player for callbacks. put this under the wkwebview and only show if we're using Youtube
        ytPlayer = YTPlayerView(frame: CGRectZero)
        ytPlayer.delegate = self
        ytPlayer.layer.cornerRadius = WildcardSDK.imageCornerRadius
        ytPlayer.layer.masksToBounds = true
        ytPlayer.backgroundColor = UIColor.blackColor()
        ytPlayer.userInteractionEnabled = true
        ytTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "videoTapped:");
        ytTapGestureRecognizer.delegate = self
        ytPlayer.addGestureRecognizer(ytTapGestureRecognizer)
        insertSubview(ytPlayer, belowSubview: videoWKView)
        ytPlayer.constrainExactlyToView(videoWKView)
        
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
        
        // spinner above poster image
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
        spinner.hidesWhenStopped = true
        spinner.setTranslatesAutoresizingMaskIntoConstraints(false)
        insertSubview(spinner, aboveSubview: passthroughView)
        addConstraint(NSLayoutConstraint(item: spinner, attribute: .CenterX, relatedBy: .Equal, toItem: videoWKView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: spinner, attribute: .CenterY, relatedBy: .Equal, toItem: videoWKView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
    }
    
    public override func adjustForPreferredWidth(cardWidth: CGFloat) {
        videoWidthConstraint.constant = cardWidth - leftConstraint.constant - rightConstraint.constant
        videoHeightConstraint.constant = round(videoWidthConstraint.constant * __videoAspectRatio)
        invalidateIntrinsicContentSize()
    }
    
    override public func update(card:Card) {
        if let videoCard = card as? VideoCard{
            
            // youtube special treatment
            if(videoCard.isYoutube()){
                videoWKView.hidden = true
                ytPlayer.hidden = false
                if let ytId = videoCard.getYoutubeId() {
                    spinner.startAnimating()
                    ytPlayer.loadWithVideoId(ytId)
                }else{
                    setError()
                    return
                }
            }else if(videoCard.streamUrl != nil){
                streamUrl = videoCard.streamUrl
            }else{
                // most general case we load embedded URL into webview
                videoWKView.hidden = false
                ytPlayer.hidden = true
                let request = NSURLRequest(URL: videoCard.embedUrl)
                spinner.startAnimating()
                videoWKView.loadRequest(request)
            }
            
            // poster image if available
            if let posterImageUrl = videoCard.posterImageUrl {
                passthroughView.hidden = false
                posterView.image = nil;
                posterView.setImageWithURL(posterImageUrl, mode: .ScaleAspectFill, completion: { (image, error) -> Void in
                    
                    if(image != nil && error == nil){
                        self.posterView.image = image
                        self.posterView.contentMode = .ScaleAspectFill
                    }else{
                        self.posterView.setNoImage()
                    }
                    
                    if(!self.videoWKView.loading){
                        self.spinner.stopAnimating()
                        self.videoActionImage.hidden = false
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
        if(gestureRecognizer == tapGestureRecognizer || gestureRecognizer == ytTapGestureRecognizer || otherGestureRecognizer == tapGestureRecognizer || otherGestureRecognizer == ytTapGestureRecognizer){
            // we want our tap gesture to be recognized alongside the WKWebView's default one
            return true;
        }else{
            return false;
        }
    }
    
    // MARK: Notification Handling
    func moviePlayerDidFinish(notification:NSNotification){
        if(cardView != nil){
            cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoWillEndPlaying, parameters: nil))
        }
        
        if let vc = parentViewController(){
            vc.dismissMoviePlayerViewControllerAnimated()
        }
        
        // remove notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer?.moviePlayer)
    }
    
    // MARK: Action
    func videoTapped(recognizer:UITapGestureRecognizer!){
        // our custom gesture recognizer on the wkwebview just to capture this engagement and flag
        WildcardSDK.analytics?.trackEvent("CardEngagement", withProperties: ["cta":"videoTapped"], withCard:cardView?.backingCard)
       
        if(streamUrl != nil){
            // have a stream url, can show a movie player automatically
            moviePlayer = MPMoviePlayerViewController(contentURL: streamUrl!)
            NSNotificationCenter.defaultCenter().removeObserver(moviePlayer!, name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer?.moviePlayer)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerDidFinish:", name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer?.moviePlayer)
            moviePlayer!.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            moviePlayer!.moviePlayer.play()
            
            if let vc = parentViewController(){
                vc.presentMoviePlayerViewControllerAnimated(moviePlayer!)
                if(self.cardView != nil){
                    self.cardView!.delegate?.cardViewRequestedAction?(self.cardView!, action: CardViewAction(type: .VideoDidStartPlaying, parameters: nil))
                }
            }
        }else{
            // using a webview, hide the poster image
            passthroughView.hidden = true
        }
    }
    
    // MARK: WKNavigationDelegate
    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!){
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        if(posterView.image != nil){
            spinner.stopAnimating()
            videoActionImage.hidden = false
        }

        // add some listeners to html5 video tag to get call backs for full screen
        videoWKView.evaluateJavaScript(getHtml5ListenerJS(), completionHandler: nil)
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        setError()
    }
    
    public func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        setError()
    }
    
    // MARK: WKScriptMessageHandler
    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage)
    {
        if let body = message.body as? String{
            if(body == "webkitbeginfullscreen"){
                if(cardView != nil){
                    cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoDidStartPlaying, parameters: nil))
                }
            }else if(body == "webkitendfullscreen"){
                if(cardView != nil){
                    cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoWillEndPlaying, parameters: nil))
                }
            }
        }
    }
    
    // MARK: YTPlayerViewDelegate
    public func playerView(playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        setError()
    }
    
    public func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        if(posterView.image != nil){
            spinner.stopAnimating()
            videoActionImage.hidden = false
        }
    }
    
    public func playerView(playerView: YTPlayerView!, didChangeToState state: YTPlayerState) {
        if(state.value == kYTPlayerStatePlaying.value){
            if(cardView != nil){
                cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoDidStartPlaying, parameters: nil))
            }
        }else if(state.value == kYTPlayerStatePaused.value){
            if(cardView != nil){
                cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoWillEndPlaying, parameters: nil))
            }
        }
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
    
    private func getHtml5ListenerJS()->String{
        var script:String?
        if let file = NSBundle.wildcardSDKBundle().pathForResource("html5VideoListeners", ofType: "js"){
            script = String(contentsOfFile: file, encoding: NSUTF8StringEncoding, error: nil)
        }
        return script!
    }

}
