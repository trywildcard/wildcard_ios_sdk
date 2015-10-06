//
//  TwitterHeader.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/23/15.
//
//

import Foundation

@objc
public class TwitterHeader : CardViewElement
{
    @IBOutlet weak var twitterIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var kicker: UILabel!
    
    /// Content insets of card card content
    public var contentEdgeInset:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(topConstraint.constant, leadingConstraint.constant, bottomConstraint.constant, trailingConstraint.constant)
        }
        set{
            topConstraint.constant = newValue.top
            leadingConstraint.constant = newValue.left
            trailingConstraint.constant = newValue.right
            bottomConstraint.constant = newValue.bottom
            invalidateIntrinsicContentSize()
        }
    }
 
    // MARK: Private
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var topConstraint: NSLayoutConstraint!
    @IBOutlet weak private var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var twitterIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var twitterIconWidthConstraint: NSLayoutConstraint!
    
    override public func initialize() {
        twitterIcon.tintColor = UIColor.twitterBlue()
        
        title.textColor = WildcardSDK.cardTitleColor
        title.font = UIFont(name:"HelveticaNeue-Medium", size: 14.0)!
        title.numberOfLines = 1
        kicker.textColor = WildcardSDK.cardKickerColor
        kicker.numberOfLines = 1
        kicker.font = UIFont(name:"HelveticaNeue-Light", size: 12.0)!
        
        contentEdgeInset = UIEdgeInsetsMake(20, 20, 20, 20)
    }
    
    override public func update(card:Card) {
        if(card.type == WCCardType.Summary){
            let summaryCard = card as! SummaryCard
            title.text = summaryCard.title
            if let subtitle = summaryCard.subtitle{
                kicker.text = "@\(subtitle)"
            }else{
                kicker.text = summaryCard.webUrl.host!
            }
        }else{
            print("This header element is not supported for type \(card.cardType) yet")
        }
    }
    
    override public func optimizedHeight(cardWidth: CGFloat) -> CGFloat {
        var height:CGFloat = 0
        height += topConstraint.constant
        height += twitterIconHeightConstraint.constant
        height += bottomConstraint.constant
        return height
    }
    
}