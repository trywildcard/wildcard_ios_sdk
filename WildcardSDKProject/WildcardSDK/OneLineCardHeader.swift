//
//  OneLineCardHeader.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class OneLineCardHeader : CardViewElement {
    
    var titleLabel:UILabel!
    
    override func initializeElement() {
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = NSTextAlignment.Left
        addSubview(titleLabel)
        titleLabel.verticallyCenterToSuperView(0)
        titleLabel.font = UIFont.wildcardStandardHeaderFont()
        titleLabel.textColor = UIColor.wildcardDarkBlue()
        titleLabel.text = "The Back!"
        backgroundColor = UIColor.whiteColor()
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10))
        
        addBottomBorderWithWidth(1.0, color: UIColor.wildcardBackgroundGray())
    }
    
    override func update() {
        super.update()
        
        switch(cardView.backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            titleLabel.setAsCardHeaderWithText(articleCard.title)
        case .WebLink:
            let webLinkCard = cardView.backingCard as WebLinkCard
            titleLabel.setAsCardHeaderWithText(webLinkCard.title)
        case .Unknown:
            titleLabel.setAsCardHeaderWithText("Unknown Card Type!")
        }
    }
    
    override class func optimizedHeight(cardWidth:CGFloat, card:Card)->CGFloat{
        return 41
    }
}