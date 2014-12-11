//
//  LinkCardPortraitDefault.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

class WebLinkCardPortraitDefaultView : CardContentView{
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomHairline: UIView!
    @IBOutlet weak var viewOnWebButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        associatedLayout = CardLayout.WebLinkCardPortraitDefault
        bottomHairline.backgroundColor = UIColor.wildcardBackgroundGray()
        titleLabel.textColor = UIColor.wildcardDarkBlue()
        titleLabel.font = UIFont.wildcardStandardHeaderFont()
    }
    
    // MARK: CardContentView
    override func updateViewForCard(card:Card){
        if let webLinkCard = card as? WebLinkCard{
            titleLabel.text = webLinkCard.title
            descriptionLabel.setAsCardSubHeaderWithText(webLinkCard.description)
        }
    }
    
    override func optimalBounds() -> CGRect {
        let screenBounds = UIScreen.mainScreen().bounds
        let cardWidth = screenBounds.width - (2*CardContentView.DEFAULT_HORIZONTAL_MARGIN)
        
        var height:CGFloat = 0
        height += 15
        height += UIFont.wildcardStandardHeaderFontLineHeight()
        height += 5
        height += Utilities.heightRequiredForText(descriptionLabel.text!,
            lineHeight: UIFont.wildcardStandardSubHeaderFontLineHeight(),
            font: UIFont.wildcardStandardSubHeaderFont(),
            width: cardWidth - (2*CardContentView.DEFAULT_HORIZONTAL_PADDING))
        height += 15
        height += 40
        
        return CGRectMake(0,0,cardWidth,height)
    }
}