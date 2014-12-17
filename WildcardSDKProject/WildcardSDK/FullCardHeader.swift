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
        switch(card.type){
        case .Article:
            let articleCard = card as ArticleCard
            title.setAsCardHeaderWithText(articleCard.title)
            kicker.setAsCardSubHeaderWithText(articleCard.publisher.name)
            if let url = articleCard.publisher.smallLogoUrl{
                favicon.downloadImageWithURL(url, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.favicon.image = image!
                    }
                })
            }
        case .WebLink:
            let webLinkCard = card as WebLinkCard
            kicker.setAsCardSubHeaderWithText(webLinkCard.title)
            title.setAsCardHeaderWithText(webLinkCard.description)
            favicon.image = UIImage(named: "wildcardSmallLogo")
        case .Unknown:
            title.setAsCardHeaderWithText("Unknown Card Type")
            favicon.image = UIImage(named: "wildcardSmallLogo")
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
            titleText = webLinkCard.description
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