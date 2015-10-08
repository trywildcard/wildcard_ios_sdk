//
//  ImageFloatLeftBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 2/20/15.
//
//

import Foundation

@objc
public class ImageFloatLeftBody : CardViewElement, WCImageViewDelegate
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
            updateDescriptionAttributes()
        }
    }
    
    /// Set this variable to control the image size. Do not attempt to reframe or relayout the imageView itself
    public var imageViewSize:CGSize{
        get{
            return CGSizeMake(imageWidthConstraint.constant, imageHeightConstraint.constant)
        }
        set{
            imageWidthConstraint.constant = newValue.width
            imageHeightConstraint.constant = newValue.height
            updateDescriptionAttributes()
        }
    }
    
    @IBOutlet weak private var descriptionImageHorizontalSpacing: NSLayoutConstraint!
    @IBOutlet weak private var imageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageHeightConstraint: NSLayoutConstraint!
    private var bottomPadding:CGFloat = 10.0
    
    override public func initialize() {
        descriptionLabel.setDefaultDescriptionStyling()
        imageViewSize = CGSizeMake(120,90)
        imageView.delegate = self
    }
    
    override public func update(card:Card) {
        if let summaryCard = card as? SummaryCard{
            descriptionLabel.text = summaryCard.abstractContent
            
            // download image
            if let imageUrl = summaryCard.primaryImageURL{
                imageView.setImageWithURL(imageUrl, mode:.ScaleAspectFill)
            }
        }else if let articleCard = card as? ArticleCard{
            descriptionLabel.text = articleCard.abstractContent
            
            if let imageUrl = articleCard.primaryImageURL{
                imageView.setImageWithURL(imageUrl, mode: .ScaleAspectFill)
            }
        }
        updateDescriptionAttributes()
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return imageHeightConstraint.constant + imageTopConstraint.constant + bottomPadding;
    }
    
    override public func adjustForPreferredWidth(cardWidth: CGFloat) {
        updateDescriptionAttributes()
    }
    
    private func updateDescriptionAttributes(){
        // description label preferred width + number of lines re calculation
        descriptionLabel.preferredMaxLayoutWidth = preferredWidth - imageLeadingConstraint.constant - descriptionImageHorizontalSpacing.constant - imageViewSize.width - imageTrailingConstraint.constant
        descriptionLabel.setRequiredNumberOfLines(descriptionLabel.preferredMaxLayoutWidth, maxHeight: imageHeightConstraint.constant)
        invalidateIntrinsicContentSize()
    }
    
    // MARK: WCImageViewDelegate
    public func imageViewTapped(imageView: WCImageView) {
        WildcardSDK.analytics?.trackEvent("CardEngagement", withProperties: ["cta":"imageTapped"], withCard:cardView?.backingCard)
        
        if(cardView != nil){
            let parameters = NSMutableDictionary()
            parameters["tappedImageView"] = imageView
            cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .ImageTapped, parameters: parameters))
        }
    }
}