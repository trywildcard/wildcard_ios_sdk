//
//  VideoCardThumbnail.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/27/15.
//
//

import Foundation

@objc
public class VideoCardThumbnail : CardViewElement, WCVideoViewDelegate {
    
    public var videoView:WCVideoView!
    public var title:UILabel!
    public var kicker:UILabel!
    
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
    
    /// Use this to change the vertical spacing between the kicker and title
    public var kickerSpacing:CGFloat{
        get{
            return kickerToTitleSpacing.constant
        }
        set{
            kickerToTitleSpacing.constant = newValue
        }
    }
    
    /// Use this to change the horizontal padding between the label and the video view
    public var labelToVideoPadding:CGFloat{
        get{
            return labelToVideoViewPadding.constant
        }
        set{
            labelToVideoViewPadding.constant = newValue;
            adjustForPreferredWidth(preferredWidth)
        }
    }
    
    private var topConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    private var rightConstraint:NSLayoutConstraint!
    private var bottomConstraint:NSLayoutConstraint!
    private var videoHeightConstraint:NSLayoutConstraint!
    private var videoWidthConstraint:NSLayoutConstraint!
    private var kickerToTitleSpacing: NSLayoutConstraint!
    private var labelToVideoViewPadding:NSLayoutConstraint!
    
    override public func initialize() {
        
        // wildcard video view
        videoView = WCVideoView(frame:CGRectZero)
        videoView.delegate = self
        addSubview(videoView)
        rightConstraint = videoView.constrainRightToSuperView(15)
        topConstraint = videoView.constrainTopToSuperView(15)
        bottomConstraint = videoView.constrainBottomToSuperView(15)
        videoWidthConstraint = videoView.constrainWidth(120)
        videoWidthConstraint.priority = 999
        videoHeightConstraint = videoView.constrainHeight(90)
        videoHeightConstraint.priority = 999
        
        kicker = UILabel(frame: CGRectZero)
        kicker.setDefaultKickerStyling()
        addSubview(kicker)
        leftConstraint = kicker.constrainLeftToSuperView(15)
        kicker.alignTopToView(videoView)
        labelToVideoViewPadding = NSLayoutConstraint(item: videoView, attribute: .Left, relatedBy: .Equal, toItem: kicker, attribute: .Right, multiplier: 1.0, constant: 15)
        addConstraint(labelToVideoViewPadding)
        
        title = UILabel(frame:CGRectZero)
        title.setDefaultTitleStyling()
        addSubview(title)
        kickerToTitleSpacing = NSLayoutConstraint(item: title, attribute: .Top, relatedBy: .Equal, toItem: kicker, attribute: .Bottom, multiplier: 1.0, constant: 3)
        addConstraint(kickerToTitleSpacing)
        title.alignLeftToView(kicker)
        title.alignRightToView(kicker)
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        height += topConstraint.constant
        height += videoHeightConstraint.constant
        height += bottomConstraint.constant
        return height
    }
    
    override public func update(card:Card) {
        if let videoCard = card as? VideoCard{
            videoView.loadVideoCard(videoCard)
            kicker.text = videoCard.creator.name
            title.text = videoCard.title
            updateLabelAttributes()
        }else{
            print("VideoCardThumbnail element should only be used with a video card.")
        }
    }
    
    private func updateLabelAttributes(){
        
        // the space available for the labels in this element
        let labelPreferredWidth = preferredWidth -
            rightConstraint.constant -
            leftConstraint.constant -
            videoWidthConstraint.constant -
            labelToVideoViewPadding.constant
        
        kicker.preferredMaxLayoutWidth = labelPreferredWidth
        title.preferredMaxLayoutWidth = labelPreferredWidth
        title.setRequiredNumberOfLines(labelPreferredWidth, maxHeight: videoHeightConstraint.constant - kicker.font.lineHeight - kickerToTitleSpacing.constant)
        invalidateIntrinsicContentSize()
    }
    
    public override func adjustForPreferredWidth(cardWidth: CGFloat) {
        updateLabelAttributes()
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