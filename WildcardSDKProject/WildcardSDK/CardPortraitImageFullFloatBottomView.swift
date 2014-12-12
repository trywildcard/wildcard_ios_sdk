//
//  WebLinkCardPortraitImageFullFloatBottomView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/11/14.
//
//

import Foundation

class CardPortraitImageFullFloatBottomView : CardContentView{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        associatedLayout = CardLayout.PortraitImageFullFloatBottom
    }
    
    override func updateViewForCard(card:Card){
        var imageUrl:NSURL?
        var titleText:String?
        var cardDescription:String?
        
        switch card.type{
        case .Unknown:
            return
        case .Article:
            let articleCard = card as ArticleCard
            imageUrl = articleCard.primaryImageURL
            titleText = String(htmlEncodedString: articleCard.title)
            if let description = articleCard.abstractContent{
                cardDescription = String(htmlEncodedString: description)
            }
        case .WebLink:
            let webLinkCard = card as WebLinkCard
            imageUrl = webLinkCard.imageUrl
            titleText = String(htmlEncodedString: webLinkCard.title)
            cardDescription = String(htmlEncodedString: webLinkCard.description)
        }
        
        if(titleText != nil){
            titleLabel.setAsCardHeaderWithText(titleText!)
        }
        if(cardDescription != nil){
            descriptionLabel.setAsCardSubHeaderWithText(cardDescription!)
        }
        if(imageUrl != nil){
            coverImageView.downloadImageWithURL(imageUrl!, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                if(image != nil){
                    self.coverImageView.image = image
                }else{
                    self.coverImageView.image = UIImage(named: "noImage")
                    self.coverImageView.contentMode = UIViewContentMode.Center
                }
            })
        }
    }
    
    override func optimalBounds() -> CGRect {
        let screenBounds = UIScreen.mainScreen().bounds
        let cardWidth = screenBounds.width - (2*CardContentView.DEFAULT_HORIZONTAL_MARGIN)
        
        var height:CGFloat = 0
        height += 10
        height += Utilities.heightRequiredForText(titleLabel.text!,
            lineHeight: UIFont.wildcardStandardHeaderFontLineHeight(),
            font: UIFont.wildcardStandardHeaderFont(),
            width: cardWidth - (2*CardContentView.DEFAULT_HORIZONTAL_PADDING))
        height += 5
        height += Utilities.heightRequiredForText(descriptionLabel.text!,
            lineHeight: UIFont.wildcardStandardSubHeaderFontLineHeight(),
            font: UIFont.wildcardStandardSubHeaderFont(),
            width: cardWidth - (2*CardContentView.DEFAULT_HORIZONTAL_PADDING))
        height += 215
        
        return CGRectMake(0,0,cardWidth,height)
    }
}