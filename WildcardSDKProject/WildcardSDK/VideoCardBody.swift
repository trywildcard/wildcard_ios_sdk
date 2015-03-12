//
//  VideoCardBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/9/15.
//
//

import Foundation
import WebKit

/// A Card Body which contains a WKWebView which is responsible for playing videos.
@objc
public class VideoCardBody : CardViewElement, WKNavigationDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate, WKScriptMessageHandler {
    
    public var videoWKView:WKWebView!
    //public var videoWKView:UIWebView!
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
    private var videoActionButton:UIButton!
    private var passthroughView:PassthroughView!
    private var videoActionImage:UIImageView!
    private var tintOverlay:UIView!
   
    override public func initialize(){
        
        // initializes the video wkwebview
        var configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = false
        configuration.mediaPlaybackRequiresUserAction = false
        
        let controller = WKUserContentController()
        controller.addScriptMessageHandler(self, name: "observe")
        
        configuration.userContentController = controller
        
        videoWKView = WKWebView(frame: CGRectZero, configuration: configuration)
        //videoWKView = UIWebView(frame: CGRectZero)
        videoWKView.layer.cornerRadius = WildcardSDK.imageCornerRadius
        videoWKView.layer.masksToBounds = true
        videoWKView.backgroundColor = UIColor.blackColor()
        videoWKView.scrollView.scrollEnabled = false
        videoWKView.scrollView.bounces = false
        //videoWKView.delegate = self
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
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoExitFullScreen:", name: UIWindowDidBecomeHiddenNotification, object: self.window)
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoEnterFullScreen:", name: UIWindowDidBecomeVisibleNotification, object: self.window)
    }
    
    func test(){
        println("test")
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
                spinner.startAnimating()
                posterView.setImageWithURL(posterImageUrl, mode: .ScaleAspectFill, completion: { (image, error) -> Void in
                    self.spinner.stopAnimating()
                    if(image != nil && error == nil){
                        self.posterView.image = image
                        self.posterView.contentMode = .ScaleAspectFill
                    }else{
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
       
        passthroughView.hidden = true
    }
    
    // MARK: WKNavigationDelegate
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        println("should start load request with url")
        
        println(request.URL.absoluteString)
        
        return true
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        println("web view finished load")
        
        let javascript = " for (var i = 0, videos = document.getElementsByTagName('video'); i < videos.length; i++) {" +
        "      videos[i].addEventListener('webkitbeginfullscreen', function(){ " +
        "           window.location = 'videohandler://begin-fullscreen';" +
        "      }, false);" +
        "      videos[i].addEventListener('webkitendfullscreen', function(){ " +
        "           window.location = 'videohandler://end-fullscreen';" +
        "      }, false);" +
        " }"
        
        let jstest = " for (var i = 0, videos = document.getElementsByTagName('video'); i < videos.length; i++) {" +
            "      alert(videos[i]);" +
            "      videos[i].addEventListener('webkitbeginfullscreen', function(){ " +
            "      alert('BEGIN');" +
            "           window.location.href = 'videohandler://begin-fullscreen';" +
            "      }, true);" +
            "      videos[i].addEventListener('webkitendfullscreen', function(){ " +
            "      alert('END');" +
            "           window.location.href = 'videohandler://end-fullscreen';" +
            "      }, true);" +
        " }"
        
        //let jstest = "var x=document.getElementsByTagName('video'); alert(x.length)"
        
        
       // println(webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML"))
      //  videoWKView.stringByEvaluatingJavaScriptFromString(javascript)
        
       // videoWKView.stringByEvaluatingJavaScriptFromString(jstest)
      //
        //videoWKView.stringByEvaluatingJavaScriptFromString("alert('hi')")
        
        /*
        [_webView stringByEvaluatingJavaScriptFromString:@" for (var i = 0, videos = document.getElementsByTagName('video'); i < videos.length; i++) {"
        @"      videos[i].addEventListener('webkitbeginfullscreen', function(){ "
        @"           window.location = 'videohandler://begin-fullscreen';"
        @"      }, false);"
        @""
        @"      videos[i].addEventListener('webkitendfullscreen', function(){ "
        @"           window.location = 'videohandler://end-fullscreen';"
        @"      }, false);"
        @" }"
        ];
*/
        
    }
    
    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!){
        spinner.startAnimating()
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        spinner.stopAnimating()
        self.videoActionImage.hidden = false

        // add some listeners to html5 video tag to get call backs for full screen
        videoWKView.evaluateJavaScript(getHtml5ListenerJS(), completionHandler: nil)
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
    
    private func getHtml5ListenerJS()->String{
        var script:String?
        if let file = NSBundle.wildcardSDKBundle().pathForResource("html5VideoListeners", ofType: "js"){
            script = String(contentsOfFile: file, encoding: NSUTF8StringEncoding, error: nil)
        }
        return script!
    }
    
    // MARK: WKScriptMessageHandler
    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage)
    {
        if let body = message.body as? String{
            if(body == "webkitbeginfullscreen"){
                if(cardView != nil){
                    cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoBeginFullScreen, parameters: nil))
                }
            }else if(body == "webkitendfullscreen"){
                if(cardView != nil){
                    cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoEndFullScreen, parameters: nil))
                }
                
            }
        }
        
    }

}
