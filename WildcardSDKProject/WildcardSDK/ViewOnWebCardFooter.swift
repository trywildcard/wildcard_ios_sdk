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
    
    public var buttonOffset:UIOffset!{
        get{
            return UIOffset(horizontal: leftConstraint.constant, vertical: verticalCenterConstraint.constant)
        }
        set{
            verticalCenterConstraint.constant = newValue.vertical
            leftConstraint.constant = newValue.horizontal
            shareButtonRightConstraint.constant = newValue.horizontal
        }
    }
    
    // MARK: Private
    private var verticalCenterConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    private var shareButtonRightConstraint:NSLayoutConstraint!
    
    override public func initializeElement() {
        viewOnWebButton = UIButton.defaultViewOnWebButton()
        addSubview(viewOnWebButton!)
        verticalCenterConstraint = viewOnWebButton?.verticallyCenterToSuperView(0)
        leftConstraint = viewOnWebButton?.constrainLeftToSuperView(15)
        hairline = addTopBorderWithWidth(0.5, color: UIColor.wildcardBackgroundGray())
        viewOnWebButton.addTarget(self, action: "viewOnWebButtonTapped", forControlEvents: .TouchUpInside)
        
        shareButton = UIButton(frame: CGRectZero)
        shareButton.tintColor = UIColor.wildcardLightBlue()
        shareButton.setImage(UIImage.loadFrameworkImage("shareIcon"), forState: .Normal)
        addSubview(shareButton)
        shareButtonRightConstraint = shareButton.constrainRightToSuperView(15)
        
        addConstraint(NSLayoutConstraint(item: shareButton, attribute: .CenterY, relatedBy: .Equal, toItem: viewOnWebButton, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        shareButton.addTarget(self, action: "shareButtonTapped", forControlEvents: .TouchUpInside)
    }
    
    func shareButtonTapped(){
        WildcardSDK.analytics?.trackEvent("CardEngaged", withProperties: ["cta":"shareAction"], withCard: backingCard)
        cardView.handleShare()
    }
    
    func viewOnWebButtonTapped(){
        WildcardSDK.analytics?.trackEvent("CardEngaged", withProperties: ["cta":"viewOnWeb"], withCard: backingCard)
        cardView.handleViewOnWeb(backingCard.webUrl)
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return 44
    }
}