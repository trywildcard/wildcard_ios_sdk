//
//  CenteredImageBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

@objc
public class ImageOnlyBody : CardViewElement{
    
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
            
            imageWidthConstraint.constant = preferredWidth - leftConstraint.constant - rightConstraint.constant
            imageHeightConstraint.constant = round(imageWidthConstraint.constant * imageAspectRatio)
            
            invalidateIntrinsicContentSize()
        }
    }
    
    private var topConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    private var rightConstraint:NSLayoutConstraint!
    private var bottomConstraint:NSLayoutConstraint!
    private var imageHeightConstraint:NSLayoutConstraint!
    private var imageWidthConstraint:NSLayoutConstraint!
    private var __imageAspectRatio:CGFloat = 0.75
    
    override public func initializeElement(){
        
        imageView = WCImageView(frame: CGRectZero)
        imageView.layer.cornerRadius = 2.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.whiteColor()
        addSubview(imageView)
        
        leftConstraint = imageView.constrainLeftToSuperView(10)
        rightConstraint = imageView.constrainRightToSuperView(10)
        topConstraint = imageView.constrainTopToSuperView(10)
        bottomConstraint = imageView.constrainBottomToSuperView(10)
        
        imageWidthConstraint = imageView.constrainWidth(preferredWidth - leftConstraint.constant - rightConstraint.constant)
        imageWidthConstraint.priority = 999
        imageHeightConstraint = imageView.constrainHeight(round(imageWidthConstraint.constant * imageAspectRatio))
        imageHeightConstraint.priority = 999
    }
    
    override public func update() {
        super.update()
        
        var imageUrl:NSURL?
        
        switch(cardView.backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            imageUrl = articleCard.primaryImageURL
        case .Summary:
            let webLinkCard = cardView.backingCard as SummaryCard
            imageUrl = webLinkCard.primaryImageURL
        case .Unknown:
            imageUrl = nil
        }
        
        // download image
        if let url = imageUrl {
            imageView.setImageWithURL(url, mode: .ScaleAspectFill)
        }
    }
    
    override public func intrinsicContentSize() -> CGSize {
        return CGSizeMake(preferredWidth, optimizedHeight(preferredWidth))
    }
    
    override public  func cardViewFinishedLayout() {
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        height += topConstraint.constant
        height += imageHeightConstraint.constant
        height += bottomConstraint.constant
        return height
    }
    
}