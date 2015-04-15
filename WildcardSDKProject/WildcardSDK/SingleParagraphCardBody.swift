//
//  SingleParagraphCardBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

/**
Most basic card body consisting of just a paragraph label
*/
@objc
public class SingleParagraphCardBody : CardViewElement {
    
    public var paragraphLabel:UILabel!
    
    public var contentEdgeInset:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(topConstraint.constant, leftConstraint.constant, bottomConstraint.constant, rightConstraint.constant)
        }
        set{
            topConstraint.constant = newValue.top
            leftConstraint.constant = newValue.left
            rightConstraint.constant = newValue.right
            bottomConstraint.constant = newValue.bottom
            
            adjustForPreferredWidth(preferredWidth)
        }
    }
    
    private var topConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    private var rightConstraint:NSLayoutConstraint!
    private var bottomConstraint:NSLayoutConstraint!
    
    override public func initialize() {
        backgroundColor = UIColor.whiteColor()
        
        paragraphLabel = UILabel(frame: CGRectZero)
        paragraphLabel.setDefaultDescriptionStyling()
        paragraphLabel.textAlignment = NSTextAlignment.Left
        paragraphLabel.numberOfLines = 0
        addSubview(paragraphLabel)
        leftConstraint = paragraphLabel.constrainLeftToSuperView(10)
        rightConstraint = paragraphLabel.constrainRightToSuperView(10)
        topConstraint = paragraphLabel.constrainTopToSuperView(5)
        bottomConstraint = paragraphLabel.constrainBottomToSuperView(5)
        
    }
    
    override public func adjustForPreferredWidth(cardWidth: CGFloat) {
        paragraphLabel.preferredMaxLayoutWidth = cardWidth - leftConstraint.constant - rightConstraint.constant
        invalidateIntrinsicContentSize()
    }
    
    override public func update(card:Card) {
        
        switch(card.type){
        case .Article:
            let articleCard = card as! ArticleCard
            paragraphLabel.text = articleCard.abstractContent
        case .Summary:
            let webLinkCard = card as! SummaryCard
            paragraphLabel.text = webLinkCard.abstractContent
        case .Video:
            let videoCard = card as! VideoCard
            paragraphLabel.text = videoCard.abstractContent
        case .Image:
            let imageCard = card as! ImageCard
            paragraphLabel.text = imageCard.imageCaption
        case .Unknown:
            paragraphLabel.text = "Unknown Card Type"
        }
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0
        height += topConstraint.constant
        
        height += Utilities.fittedHeightForLabel(paragraphLabel, labelWidth: cardWidth - leftConstraint.constant - rightConstraint.constant)
        
        height += bottomConstraint.constant
        return round(height)
    }
    
 
}