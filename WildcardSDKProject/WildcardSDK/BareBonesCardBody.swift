//
//  BareBonesCardBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class BareBonesCardBody : CardViewElement {
    
    var titleLabel:UILabel!
    var viewOnWebButton:UIButton!
    
    override func initializeElement(){
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.Center
        addSubview(titleLabel)
        titleLabel.verticallyCenterToSuperView(-20)
        titleLabel.font = UIFont.wildcardLargePlaceholderFont()
        titleLabel.textColor = UIColor.wildcardDarkBlue()
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 15))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -15))
    }
    
    override func updateForCard(card: Card) {
        switch(card.type){
        case .Article:
            let articleCard = card as ArticleCard
            titleLabel.text = articleCard.title
        case .WebLink:
            let webLinkCard = card as WebLinkCard
            titleLabel.text = webLinkCard.title
        case .Unknown:
            titleLabel.text = "Unknown Card Type!"
        }
    }
}