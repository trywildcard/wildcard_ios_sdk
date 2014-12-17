//
//  FullCardHeader.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class FullCardHeader :CardViewElement
{
    @IBOutlet weak var favicon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var kicker: UILabel!
    
    override func initializeElement() {
        favicon.layer.cornerRadius = 4.0
        favicon.layer.masksToBounds = true
    }
    
    override func updateForCard(card: Card) {
        kicker.setAsCardSubHeaderWithText("Card Kicker!")
        favicon.image = UIImage(named: "wildcardSmallLogo")
        
        switch(card.type){
        case .Article:
            let articleCard = card as ArticleCard
            title.setAsCardHeaderWithText(articleCard.title)
        case .WebLink:
            let webLinkCard = card as WebLinkCard
            title.setAsCardHeaderWithText(webLinkCard.title)
        case .Unknown:
            title.setAsCardHeaderWithText("Unknown Card Type")
        }
    }
    
    override class func optimizedHeight(cardWidth:CGFloat, card:Card)->CGFloat{
        
        var titleText:String?
        switch(card.type){
        case .Article:
            let articleCard = card as ArticleCard
            titleText = articleCard.title
        case .WebLink:
            let webLinkCard = card as WebLinkCard
            titleText = webLinkCard.title
        case .Unknown:
            titleText = "Unknown Card Type"
        }
        
        var height:CGFloat = 0
        height += 7
        height += UIFont.wildcardStandardSubHeaderFontLineHeight()
        height += 4
        height += Utilities.heightRequiredForText(titleText!, lineHeight: UIFont.wildcardStandardHeaderFontLineHeight(), font: UIFont.wildcardStandardHeaderFont(), width: cardWidth - 65, maxHeight:3 * UIFont.wildcardStandardHeaderFontLineHeight())
        height += 11
        return height
    }
    
}