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
public class SingleParagraphCardBody : CardViewElement {
    
    public var paragraphLabel:UILabel!
    
    public var paragraphLabelEdgeInsets:UIEdgeInsets{
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
    
    override public func initializeElement() {
        backgroundColor = UIColor.whiteColor()
        
        paragraphLabel = UILabel(frame: CGRectZero)
        paragraphLabel.textColor = UIColor.wildcardMediaBodyColor()
        paragraphLabel.font = WildcardSDK.cardDescriptionFont
        paragraphLabel.textAlignment = NSTextAlignment.Left
        paragraphLabel.numberOfLines = 0
        addSubview(paragraphLabel)
        leftConstraint = paragraphLabel.constrainLeftToSuperView(10)
        rightConstraint = paragraphLabel.constrainRightToSuperView(10)
        topConstraint = paragraphLabel.constrainTopToSuperView(5)
        bottomConstraint = paragraphLabel.constrainBottomToSuperView(10)
    }
    
    override public func update() {
        super.update()
        
        switch(backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            paragraphLabel.text = articleCard.abstractContent
        case .Summary:
            let webLinkCard = cardView.backingCard as SummaryCard
            paragraphLabel.text = webLinkCard.abstractContent
        case .Unknown:
            paragraphLabel.text = "Unknown Card Type"
        }
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0
        height += topConstraint.constant
        let expectedParagraphSize = paragraphLabel.sizeThatFits(CGSizeMake(cardWidth - leftConstraint.constant - rightConstraint.constant, CGFloat.max))
        height += ceil(expectedParagraphSize.height)
        height += bottomConstraint.constant
        return height
    }
    
 
}