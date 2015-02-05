//
//  ImageThumbnailFloatRight.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

@objc
public class ImageFloatRightBody : CardViewElement
{
    @IBOutlet weak public var imageView: WCImageView!
    @IBOutlet weak public var descriptionLabel: UILabel!
    
    /// Content inset for all content of card body
    public var contentEdgeInset:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(imageTopConstraint.constant, imageLeadingConstraint.constant, bottomPadding, imageTrailingConstraint.constant)
        }
        set{
            imageTopConstraint.constant = newValue.top
            imageLeadingConstraint.constant = newValue.left
            imageTrailingConstraint.constant = newValue.right
            bottomPadding = newValue.bottom
        }
    }
    
    /// Set this variable to control the image size. Do not attempt to reframe or relayout the imageView
    public var imageViewSize:CGSize{
        get{
            return CGSizeMake(imageWidthConstraint.constant, imageHeightConstraint.constant)
        }
        set{
            imageWidthConstraint.constant = newValue.width
            imageHeightConstraint.constant = newValue.height
        }
    }
    
    @IBOutlet weak private var imageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageHeightConstraint: NSLayoutConstraint!
    private var bottomPadding:CGFloat = 10.0
    
    override public func initializeElement() {
        descriptionLabel.font = WildcardSDK.cardDescriptionFont
        descriptionLabel.textColor = UIColor.wildcardMediaBodyColor()
        imageView.layer.cornerRadius = 2.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.wildcardBackgroundGray()
        imageViewSize = CGSizeMake(120,90)
    }
    
    override public func update() {
        if let summaryCard = cardView.backingCard as? SummaryCard{
            descriptionLabel.text = summaryCard.abstractContent
            
            // download image
            if let imageUrl = summaryCard.primaryImageURL{
                imageView.setImageWithURL(imageUrl, mode:.ScaleAspectFill)
            }
        }else if let articleCard = cardView.backingCard as? ArticleCard{
            descriptionLabel.text = articleCard.abstractContent
            
            if let imageUrl = articleCard.primaryImageURL{
                imageView.setImageWithURL(imageUrl, mode: .ScaleAspectFill)
            }
        }
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return imageHeightConstraint.constant + imageTopConstraint.constant + bottomPadding;
    }
    
    override public func cardViewFinishedLayout() {
        // we're laid out now, can calculate the lines now
        descriptionLabel.setRequiredNumberOfLines(imageView.frame.size.height)
    }
}