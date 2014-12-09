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
        titleLabel.font = UIFont(name: "Polaris-Light", size: 24.0)
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
}