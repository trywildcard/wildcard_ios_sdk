//
//  WebLinkCardPortraitImageSmallFloatLeftView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import Foundation

class WebLinkCardPortraitImageSmallFloatLeftView : CardContentView{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomHairline: UIView!
    @IBOutlet weak var viewOnWebButton: UIButton!
    @IBOutlet weak var cardImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        associatedLayout = CardLayout.WebLinkCardPortraitImageSmallFloatLeft
        bottomHairline.backgroundColor = UIColor.wildcardBackgroundGray()
        titleLabel.textColor = UIColor.wildcardDarkBlue()
        titleLabel.font = UIFont.wildcardStandardHeaderFont()
    }

    override func updateViewForCard(card:Card){
        var imageUrl:NSURL?
        var titleText:String?
        
        if let webLinkCard = card as? WebLinkCard{
            titleLabel.setAsCardHeaderWithText(String(htmlEncodedString: webLinkCard.title))
            descriptionLabel.setAsCardSubHeaderWithText(String(htmlEncodedString: webLinkCard.description))
            
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
    
    
    override func optimalBounds() -> CGRect {
        let screenBounds = UIScreen.mainScreen().bounds
        let cardWidth = screenBounds.width - (2*CardContentView.DEFAULT_HORIZONTAL_MARGIN)
        return CGRectMake(0,0,cardWidth, 180)
    }
}