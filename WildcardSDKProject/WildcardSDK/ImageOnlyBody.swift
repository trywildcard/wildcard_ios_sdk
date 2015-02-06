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
    public var imageAspectRatio:CGFloat = 0.75
    public var contentEdgeInsets:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(topConstraint.constant, leftConstraint.constant, bottomConstraint.constant, rightConstraint.constant)
        }
        set{
            topConstraint.constant = newValue.top
            leftConstraint.constant = newValue.left
            rightConstraint.constant = newValue.right
            bottomConstraint.constant = newValue.bottom
        }
    }
    
    private var topConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    private var rightConstraint:NSLayoutConstraint!
    private var bottomConstraint:NSLayoutConstraint!
    
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
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        height += topConstraint.constant
        height += bottomConstraint.constant
        height += imageAspectRatio * (cardWidth - leftConstraint.constant - rightConstraint.constant)
        return height
    }
    
}