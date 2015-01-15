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
    @IBOutlet weak var kicker: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func initializeElement() {
        favicon.layer.cornerRadius = 4.0
        favicon.layer.masksToBounds = true
    }
    
    override func update() {
        
        super.update()
        
        switch(backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            title.setAsCardHeaderWithText(articleCard.title)
            kicker.setAsCardSubHeaderWithText(articleCard.publisher.name)
            if let url = articleCard.publisher.smallLogoUrl{
                favicon.downloadImageWithURL(url, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.favicon.image = image!
                    }
                })
            }
        case .Summary:
            let summaryCard = cardView.backingCard as SummaryCard
            kicker.setAsCardSubHeaderWithText(summaryCard.title)
            title.setAsCardHeaderWithText(summaryCard.description)
            favicon.image = UIImage(named: "wildcardSmallLogo")
        case .Unknown:
            title.setAsCardHeaderWithText("Unknown Card Type")
            favicon.image = UIImage(named: "wildcardSmallLogo")
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        
        var titleText:String?
        switch(cardView.backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            titleText = articleCard.title
        case .Summary:
            let summaryCard = cardView.backingCard as SummaryCard
            titleText = summaryCard.description
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