//
//  WCVideoView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/16/15.
//
//

import Foundation
import MediaPlayer
import WebKit

@objc
public protocol WCVideoViewDelegate{
    
    optional func videoViewDidStartPlaying(videoView:WCVideoView)
    optional func videoViewWillEndPlaying(videoView:WCVideoView)
    optional func videoViewTapped(videoView:WCVideoView)
}

/// Plays content from a Video Card
@objc
public class WCVideoView : UIView, WKNavigationDelegate, UIGestureRecognizerDelegate, WKScriptMessageHandler, YTPlayerViewDelegate  {
    
    public var videoCard:VideoCard?
    public var delegate:WCVideoViewDelegate?
    
    private var videoWKView:WKWebView!
    private var ytPlayer:YTPlayerView!
    private var posterView:WCImageView!
    private var tapGestureRecognizer:UITapGestureRecognizer!
    private var ytTapGestureRecognizer:UITapGestureRecognizer!
    private var passthroughView:PassthroughView!
    private var videoActionImage:UIImageView!
    private var tintOverlay:UIView!
    private var spinner:UIActivityIndicatorView!
    private var moviePlayer:MPMoviePlayerViewController?
    private var streamUrl:NSURL?
    private var inError:Bool = false
    
    func initialize(){
        
        backgroundColor = UIColor.blackColor()
        userInteractionEnabled = true
        
        // initializes the video wkwebview
        let controller = WKUserContentController()
        controller.addScriptMessageHandler(self, name: "observe")
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = false
        configuration.mediaPlaybackRequiresUserAction = true
        configuration.userContentController = controller
        
        videoWKView = WKWebView(frame: CGRectZero, configuration: configuration)
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
        videoWKView.constrainToSuperViewEdges()

        // youtube has its own player for callbacks. put this under the wkwebview and only show if we're using Youtube
        ytPlayer = YTPlayerView(frame: CGRectZero)
        ytPlayer.delegate = self
        ytPlayer.backgroundColor = UIColor.blackColor()
        ytPlayer.userInteractionEnabled = true
        ytTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "videoTapped:");
        ytTapGestureRecognizer.delegate = self
        ytPlayer.addGestureRecognizer(ytTapGestureRecognizer)
        insertSubview(ytPlayer, belowSubview: videoWKView)
        ytPlayer.constrainExactlyToView(videoWKView)
        
        // pass through view on top of webview for a poster image
        passthroughView = PassthroughView(frame:CGRectZero)
        passthroughView.userInteractionEnabled = false
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
        videoActionImage.translatesAutoresizingMaskIntoConstraints = false
        videoActionImage.image = UIImage.loadFrameworkImage("playIcon")
        videoActionImage.hidden = true
        passthroughView.insertSubview(videoActionImage, aboveSubview: posterView)
        passthroughView.addSubview(videoActionImage)
        addConstraint(NSLayoutConstraint(item: videoActionImage, attribute: .CenterX, relatedBy: .Equal, toItem: passthroughView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: videoActionImage, attribute: .CenterY, relatedBy: .Equal, toItem: passthroughView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        // spinner above poster image
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(spinner, aboveSubview: passthroughView)
        addConstraint(NSLayoutConstraint(item: spinner, attribute: .CenterX, relatedBy: .Equal, toItem: videoWKView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: spinner, attribute: .CenterY, relatedBy: .Equal, toItem: videoWKView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
    }
    
    func loadVideoCard(videoCard:VideoCard){
        inError = false
        self.videoCard = videoCard

        // poster image if available
        if let posterImageUrl = videoCard.posterImageUrl {
            posterView.image = nil;
            posterView.setImageWithURL(posterImageUrl, mode: .ScaleAspectFill, completion: { (image, error) -> Void in
                if(self.inError == false){
                    if(image != nil && error == nil){
                        self.posterView.setImage(image!, mode:.ScaleAspectFill)
                    }else{
                        self.posterView.setNoImage()
                    }
                }else{
                    self.setError()
                }
            })
        }else{
            posterView.setNoImage()
        }
        
        if(videoCard.isYoutube()){
            // youtube special treatment
            streamUrl = nil
            videoWKView.hidden = true
            ytPlayer.hidden = false
            if let ytId = videoCard.getYoutubeId() {
                setLoading(true)
                ytPlayer.loadWithVideoId(ytId)
            }else{
                print("Shouldn't happen -- Video Card with Youtube creator is malformed.")
                setError()
                return
            }
        }else if(videoCard.isVimeo()){
            // vimeo special treatment
            self.setLoading(true)
            YTVimeoExtractor.fetchVideoURLFromURL(videoCard.embedUrl.absoluteString, quality: YTVimeoVideoQualityMedium, completionHandler: { (url, error, quality) -> Void in
                if(url != nil && error == nil){
                    self.streamUrl = url
                    self.setLoading(false)
                }else{
                    self.setError()
                }
            })
        }else if(videoCard.streamUrl != nil){
            // direct stream available
            streamUrl = videoCard.streamUrl
            videoActionImage.hidden = false
            setLoading(false)
        }else{
            // most general case we load embedded URL into webview
            streamUrl = nil
            videoWKView.hidden = false
            ytPlayer.hidden = true
            setLoading(true)
            videoWKView.loadRequest(NSURLRequest(URL: videoCard.embedUrl))
        }
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
        delegate?.videoViewWillEndPlaying?(self)
       
        if let vc = parentViewController(){
            vc.dismissMoviePlayerViewControllerAnimated()
        }
        
        // remove notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer?.moviePlayer)
    }
    
    // MARK: Action
    func videoTapped(recognizer:UITapGestureRecognizer!){
        
        delegate?.videoViewTapped?(self)
        
        if(inError){
            // attempt reload if we're in error state
            if let card = videoCard {
                loadVideoCard(card)
            }
        }else{
            if(streamUrl != nil){
                // have a stream url, can show a movie player automatically
                moviePlayer = MPMoviePlayerViewController(contentURL: streamUrl!)
                NSNotificationCenter.defaultCenter().removeObserver(moviePlayer!, name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer?.moviePlayer)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerDidFinish:", name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer?.moviePlayer)
                moviePlayer!.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                moviePlayer!.moviePlayer.play()
                
                if let vc = parentViewController(){
                    vc.presentMoviePlayerViewControllerAnimated(moviePlayer!)
                    delegate?.videoViewDidStartPlaying?(self)
                }
            }else{
                // using a webview, hide the poster image
                passthroughView.hidden = true
            }
        }
    }
    
    // MARK: WKNavigationDelegate
    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!){
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        setLoading(false)
        
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
    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        if let body = message.body as? String{
            if(body == "webkitbeginfullscreen"){
                delegate?.videoViewDidStartPlaying?(self)
            }else if(body == "webkitendfullscreen"){
                delegate?.videoViewWillEndPlaying?(self)
            }
        }
    }
    
    // MARK: YTPlayerViewDelegate
    public func playerView(playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        setError()
    }
    
    public func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        setLoading(false)
    }
    
    public func playerView(playerView: YTPlayerView!, didChangeToState state: YTPlayerState) {
        if(state.rawValue == kYTPlayerStatePlaying.rawValue){
            delegate?.videoViewDidStartPlaying?(self)
        }else if(state.rawValue == kYTPlayerStatePaused.rawValue){
            delegate?.videoViewWillEndPlaying?(self)
        }
    }
    
    // MARK: Private
    private func setError(){
        passthroughView.hidden = false
        spinner.stopAnimating()
        posterView.cancelRequest()
        posterView.image = nil
        videoActionImage.hidden = false
        videoActionImage.image = UIImage.loadFrameworkImage("noVideoFound")
        inError = true
    }
    
    private func getHtml5ListenerJS()->String{
        var script:String?
        if let file = NSBundle.wildcardSDKBundle().pathForResource("html5VideoListeners", ofType: "js"){
            script = try? String(contentsOfFile: file, encoding: NSUTF8StringEncoding)
        }
        return script!
    }
    
    private func setLoading(loading:Bool){
        if(loading){
            videoActionImage.hidden = true
            spinner.startAnimating()
        }else{
            videoActionImage.hidden = false
            spinner.stopAnimating()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame:frame)
        initialize()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
}