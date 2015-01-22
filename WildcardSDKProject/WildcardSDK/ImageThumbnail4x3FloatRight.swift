//
//  ImageThumbnailFloatRight.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

class ImageThumbnail4x3FloatRight : CardViewElement
{
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var kicker: UILabel!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    override func initializeElement() {
        kicker.font = WildcardSDK.cardKickerFont
        kicker.textColor = UIColor.wildcardMediumGray()
        title.font = WildcardSDK.cardTitleFont
        title.textColor = UIColor.wildcardDarkBlue()
        descriptionLabel.font = WildcardSDK.cardDescriptionFont
        descriptionLabel.textColor = UIColor.wildcardMediaBodyColor()
        imageView.layer.cornerRadius = 2.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.wildcardBackgroundGray()
    }
    
    override func update() {
        
        if let summaryCard = cardView.backingCard as? SummaryCard{
            kicker.text = summaryCard.webUrl.host
            title.text = summaryCard.title
            descriptionLabel.text = summaryCard.description
            
            // download image
            if let imageUrl = summaryCard.imageUrl{
                imageView.downloadImageWithURL(imageUrl, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.imageView.image = image
                        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
                    }
                })
            }
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return imageViewHeight.constant + 20
    }
}