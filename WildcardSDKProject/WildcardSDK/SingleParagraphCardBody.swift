//
//  SingleParagraphCardBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class SingleParagraphCardBody : CardViewElement {
    
    var titleLabel:UILabel!
    
    override func initializeElement() {
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.Left
        addSubview(titleLabel)
        titleLabel.verticallyCenterToSuperView(-2)
        titleLabel.font = UIFont.wildcardStandardSubHeaderFont()
        titleLabel.textColor = UIColor.wildcardMediumGray()
        backgroundColor = UIColor.whiteColor()
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10))
    }
    
    override func update() {
        super.update()
        
        switch(backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            titleLabel.setAsCardSubHeaderWithText(articleCard.abstractContent)
        case .Summary:
            let webLinkCard = cardView.backingCard as SummaryCard
            titleLabel.setAsCardSubHeaderWithText(webLinkCard.description)
        case .Unknown:
            titleLabel.setAsCardSubHeaderWithText("Unknown Card Type!")
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        
        var titleText:String?
        
        switch(backingCard.type){
        case .Article:
            let articleCard = backingCard as ArticleCard
            titleText = articleCard.abstractContent
        case .Summary:
            let webLinkCard = backingCard as SummaryCard
            titleText = webLinkCard.description
        case .Unknown:
            titleText = nil
        }
        
        if(titleText != nil){
            var height:CGFloat = 0;
            height += Utilities.heightRequiredForText(titleText!, lineHeight: UIFont.wildcardStandardSubHeaderFontLineHeight(), font: UIFont.wildcardStandardSubHeaderFont(), width: (cardWidth - (2*10)))
            return height + 18
        }else{
            return CGFloat.min
        }
    }
}