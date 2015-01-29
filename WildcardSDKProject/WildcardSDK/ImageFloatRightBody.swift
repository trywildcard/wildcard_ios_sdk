//
//  ImageThumbnailFloatRight.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

class ImageFloatRightBody : CardViewElement
{
    @IBOutlet weak var imageView: WCImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    override func initializeElement() {
        descriptionLabel.font = WildcardSDK.cardDescriptionFont
        descriptionLabel.textColor = UIColor.wildcardMediaBodyColor()
        imageView.layer.cornerRadius = 2.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.wildcardBackgroundGray()
    }
    
    override func update() {
        
        if let summaryCard = cardView.backingCard as? SummaryCard{
            descriptionLabel.text = summaryCard.abstractContent
            
            // download image
            if let imageUrl = summaryCard.imageUrl{
                imageView.setImageWithURL(imageUrl, mode:.ScaleAspectFill)
            }
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return imageViewHeight.constant + 20
    }
}