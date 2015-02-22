//
//  ViewOnWebFooter.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

@objc
public class ViewOnWebCardFooter: CardViewElement {
    
    public var viewOnWebButton:UIButton!
    public var shareButton:UIButton!
    public var hairline:UIView!
    
    public var contentEdgeInset:UIEdgeInsets{
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
    
    // MARK: Private
    private var topConstraint:NSLayoutConstraint!
    private var bottomConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    private var rightConstraint:NSLayoutConstraint!
    
    override public func initialize() {
        viewOnWebButton = UIButton.defaultViewOnWebButton()
        addSubview(viewOnWebButton!)
        leftConstraint = viewOnWebButton?.constrainLeftToSuperView(15)
        topConstraint = viewOnWebButton?.constrainTopToSuperView(10)
        bottomConstraint = viewOnWebButton?.constrainBottomToSuperView(10)
        
        hairline = addTopBorderWithWidth(0.5, color: UIColor.wildcardBackgroundGray())
        viewOnWebButton.addTarget(self, action: "viewOnWebButtonTapped", forControlEvents: .TouchUpInside)
        
        shareButton = UIButton(frame: CGRectZero)
        shareButton.tintColor = UIColor.wildcardLightBlue()
        shareButton.setImage(UIImage.loadFrameworkImage("shareIcon"), forState: .Normal)
        addSubview(shareButton)
        rightConstraint = shareButton.constrainRightToSuperView(15)
        
        addConstraint(NSLayoutConstraint(item: shareButton, attribute: .CenterY, relatedBy: .Equal, toItem: viewOnWebButton, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        shareButton.addTarget(self, action: "shareButtonTapped", forControlEvents: .TouchUpInside)
    }
    
    func shareButtonTapped(){
        if(cardView != nil){
            WildcardSDK.analytics?.trackEvent("CardEngaged", withProperties: ["cta":"shareAction"], withCard: cardView!.backingCard)
            cardView!.handleShare()
        }
    }
    
    func viewOnWebButtonTapped(){
        if(cardView != nil){
            WildcardSDK.analytics?.trackEvent("CardEngaged", withProperties: ["cta":"viewOnWeb"], withCard: cardView!.backingCard)
            cardView!.handleViewOnWeb(cardView!.backingCard.webUrl)
        }
    }
    
    override public func adjustForPreferredWidth(cardWidth: CGFloat) {
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0
        height += topConstraint.constant
        height += viewOnWebButton.intrinsicContentSize().height
        height += bottomConstraint.constant
        return round(height)
    }
}