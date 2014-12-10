//
//  LinkCardPortraitDefault.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

class LinkCardPortraitDefaultView : CardContentView{
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomHairline: UIView!
    @IBOutlet weak var viewOnWebButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        associatedLayout = CardLayout.LinkCardPortraitDefault
        titleLabel.font = UIFont.wildcardStandardTitleFont()
        titleLabel.textColor = UIColor.wildcardDarkBlue()
        descriptionLabel.font = UIFont.wildcardStandardDescriptionFont()
        descriptionLabel.textColor = UIColor.wildcardMediumGray()
        bottomHairline.backgroundColor = UIColor.wildcardBackgroundGray()
    }
    
    // MARK: CardContentView
    override func updateViewForCard(card:Card){
        if let webLinkCard = card as? WebLinkCard{
            titleLabel.text = webLinkCard.title
            descriptionLabel.text = webLinkCard.description
        }
    }
    
    override func optimalBounds() -> CGSize {
        let screenBounds = UIScreen.mainScreen().bounds
        let cardWidth = screenBounds.width - (2*CardContentView.DEFAULT_HORIZONTAL_PADDING)
 //         let infinitHeightBound = CGRectMake(0, 0, cardWidth, 1000)
        
        /*
        println(subviews)
        sizeToFit()
        println(subviews)
        let maxSize = CGSizeMake(10, CGFloat.max)
        let requiredSize = titleLabel.sizeThatFits(maxSize)
        frame = CGRectMake(0, 0, requiredSize.width, requiredSize.height)
        
        println(frame)
*/
        

        
        let cardHeight = cardWidth * (3/4)
        return CGSizeMake(cardWidth, cardHeight)
    }
}