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
public class VideoCardBody : CardViewElement, WCVideoViewDelegate{
    
    public var videoView:WCVideoView!
    
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
   
    override public func initialize(){
        
        // wildcard video view
        videoView = WCVideoView(frame:CGRectZero)
        videoView.delegate = self
        addSubview(videoView)
        leftConstraint = videoView.constrainLeftToSuperView(10)
        rightConstraint = videoView.constrainRightToSuperView(10)
        topConstraint = videoView.constrainTopToSuperView(10)
        bottomConstraint = videoView.constrainBottomToSuperView(10)
        videoWidthConstraint = videoView.constrainWidth(0)
        videoWidthConstraint.priority = 999
        videoHeightConstraint = videoView.constrainHeight(0)
        videoHeightConstraint.priority = 999
    }
    
    public override func adjustForPreferredWidth(cardWidth: CGFloat) {
        videoWidthConstraint.constant = cardWidth - leftConstraint.constant - rightConstraint.constant
        videoHeightConstraint.constant = round(videoWidthConstraint.constant * __videoAspectRatio)
        invalidateIntrinsicContentSize()
    }
    
    override public func update(card:Card) {
        if let videoCard = card as? VideoCard{
            videoView.loadVideoCard(videoCard)
        }else{
            print("VideoCardBody element should only be used with a video card.")
        }
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        height += topConstraint.constant
        height += videoHeightConstraint.constant
        height += bottomConstraint.constant
        return height
    }
    
    // MARK: WCVideoViewDelegate
    public func videoViewTapped(videoView: WCVideoView) {
        WildcardSDK.analytics?.trackEvent("CardEngagement", withProperties: ["cta":"videoTapped"], withCard:cardView?.backingCard)
    }
    
    public func videoViewDidStartPlaying(videoView: WCVideoView) {
        if(cardView != nil){
            cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoDidStartPlaying, parameters:nil))
        }
    }
    
    public func videoViewWillEndPlaying(videoView: WCVideoView) {
        if(cardView != nil){
            cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .VideoWillEndPlaying, parameters:nil))
        }
    }
    


}
