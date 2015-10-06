//
//  CenteredImageBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

@objc
public class ImageOnlyBody : CardViewElement, WCImageViewDelegate{
    
    public var imageView:WCImageView!
    
    /// Adjusts the aspect ratio of the image view.
    public var imageAspectRatio:CGFloat{
        get{
            return __imageAspectRatio
        }
        set{
            __imageAspectRatio = newValue
            imageHeightConstraint.constant = round(imageWidthConstraint.constant * __imageAspectRatio)
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
    private var imageHeightConstraint:NSLayoutConstraint!
    private var imageWidthConstraint:NSLayoutConstraint!
    private var __imageAspectRatio:CGFloat = 0.75
    
    override public func initialize(){
        
        imageView = WCImageView(frame: CGRectZero)
        imageView.delegate = self
        addSubview(imageView)
        
        leftConstraint = imageView.constrainLeftToSuperView(10)
        rightConstraint = imageView.constrainRightToSuperView(10)
        topConstraint = imageView.constrainTopToSuperView(10)
        bottomConstraint = imageView.constrainBottomToSuperView(10)
        
        imageWidthConstraint = imageView.constrainWidth(0)
        imageWidthConstraint.priority = 999
        imageHeightConstraint = imageView.constrainHeight(0)
        imageHeightConstraint.priority = 999
    }
    
    public override func adjustForPreferredWidth(cardWidth: CGFloat) {
        imageWidthConstraint.constant = cardWidth - leftConstraint.constant - rightConstraint.constant
        imageHeightConstraint.constant = round(imageWidthConstraint.constant * imageAspectRatio)
        invalidateIntrinsicContentSize()
    }
    
    override public func update(card:Card) {
        
        var imageUrl:NSURL?
        
        switch(card.type){
        case .Article:
            let articleCard = card as! ArticleCard
            imageUrl = articleCard.primaryImageURL
        case .Summary:
            let webLinkCard = card as! SummaryCard
            imageUrl = webLinkCard.primaryImageURL
        case .Image:
            let imageCard = card as! ImageCard
            imageUrl = imageCard.imageUrl
        case .Unknown, .Video:
            imageUrl = nil
        }
        
        // download image
        if let url = imageUrl {
            imageView.setImageWithURL(url, mode: .ScaleAspectFill)
        }
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        height += topConstraint.constant
        height += imageHeightConstraint.constant
        height += bottomConstraint.constant
        return height
    }
    
    // MARK: WCImageViewDelegate
    public func imageViewTapped(imageView: WCImageView) {
        WildcardSDK.analytics?.trackEvent("CardEngagement", withProperties: ["cta":"imageTapped"], withCard:cardView?.backingCard)
        
        if(cardView != nil){
            let parameters = NSMutableDictionary()
            parameters["tappedImageView"] = imageView
            cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .ImageTapped, parameters: parameters))
        }
    }
    
}