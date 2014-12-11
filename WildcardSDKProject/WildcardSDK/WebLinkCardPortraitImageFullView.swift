//
//  LinkCardPortraitImageFull.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import Foundation

class WebLinkCardPortraitImageFullView : CardContentView{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cardImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        associatedLayout = CardLayout.WebLinkCardPortraitImageFull
        titleLabel.font = UIFont.wildcardStandardHeaderFont()
        titleLabel.textColor = UIColor.wildcardDarkBlue()
    }
    
    override func updateViewForCard(card:Card){
        var imageUrl:NSURL?
        var titleText:String?
        
        if let webLinkCard = card as? WebLinkCard{
            titleLabel.text = webLinkCard.title
            
            // download image
            if let imageUrl = webLinkCard.imageUrl{
                cardImageView.downloadImageWithURL(imageUrl, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.cardImageView.image = image
                    }else{
                        self.cardImageView.image = UIImage(named: "noImage")
                        self.cardImageView.contentMode = UIViewContentMode.Center
                    }
                })
            }
        }
    }
    
    override func optimalBounds() -> CGRect{
        let screenBounds = UIScreen.mainScreen().bounds
        let cardWidth = screenBounds.width - (2*CardContentView.DEFAULT_HORIZONTAL_MARGIN)
        let cardHeight = cardWidth * (3/4)
        return CGRectMake(0,0,cardWidth, cardHeight)
    }
}