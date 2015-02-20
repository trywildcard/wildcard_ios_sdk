//
//  TallReadMoreCardFooter.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

@objc
public class ReadMoreFooter: CardViewElement {
    
    /// Read More Button. Always left aligned at the moment.
    public var readMoreButton:UIButton!
    
    /// Content insets. Right inset for this element does nothing at the moment.
    public var contentEdgeInset:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(topConstraint.constant, leftConstraint.constant, bottomConstraint.constant, 0)
        }
        set{
            leftConstraint.constant = newValue.left
            bottomConstraint.constant = newValue.bottom
            topConstraint.constant = newValue.top
        }
    }
    
    // MARK: Private
    private var leftConstraint:NSLayoutConstraint!
    private var topConstraint:NSLayoutConstraint!
    private var bottomConstraint:NSLayoutConstraint!
    
    override public func initialize() {
        readMoreButton = UIButton.defaultReadMoreButton()
        addSubview(readMoreButton!)
        
        leftConstraint = readMoreButton?.constrainLeftToSuperView(15)
        topConstraint = readMoreButton?.constrainTopToSuperView(10)
        bottomConstraint = readMoreButton?.constrainBottomToSuperView(10)
        
        readMoreButton.addTarget(self, action: "readMoreButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0
        height += topConstraint.constant
        height += readMoreButton.intrinsicContentSize().height
        height += bottomConstraint.constant
        return round(height)
    }
    
    override public func adjustForPreferredWidth(cardWidth: CGFloat) {
    }
    
    func readMoreButtonTapped(){
        WildcardSDK.analytics?.trackEvent("CardEngaged", withProperties: ["cta":"readMore"], withCard: cardView?.backingCard)
        if(cardView != nil){
            cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .Maximize, parameters: nil))
        }
    }
}