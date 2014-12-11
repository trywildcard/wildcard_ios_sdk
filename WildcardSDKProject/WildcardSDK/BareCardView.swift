//
//  BareCardView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation
import UIKit

class BareCardView : CardContentView{
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        associatedLayout = CardLayout.BareCard
        titleLabel.font = UIFont(name: "Polaris-Light", size: 28.0)
    }
    
    override func updateViewForCard(card:Card){
        switch card.type{
        case .Unknown:
            return
        case .Article:
            let articleCard = card as ArticleCard
            titleLabel.text = articleCard.title
        case .WebLink:
            let webLinkCard = card as WebLinkCard
            titleLabel.text = webLinkCard.title
        }
    }
    
    override func optimalBounds() -> CGSize{
        let screenBounds = UIScreen.mainScreen().bounds
        let cardWidth = screenBounds.width - (2*CardContentView.DEFAULT_HORIZONTAL_MARGIN)
        let cardHeight = cardWidth * (3/4)
        // do a standard 4 x 3 relative to the screen width
        return CGSizeMake(cardWidth, cardHeight)
    }
}