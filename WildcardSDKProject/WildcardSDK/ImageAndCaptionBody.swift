//
//  ImageWithCaption.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/16/15.
//
//

import Foundation

/**
Card Body with an image and a caption under it.
*/
@objc
public class ImageAndCaptionBody : CardViewElement, WCImageViewDelegate{
    
    @IBOutlet weak public var imageView: WCImageView!
    @IBOutlet weak public var caption: UILabel!
    
    /// Adjusts the aspect ratio of the image view.
    public var imageAspectRatio:CGFloat{
        get{
            return __imageAspectRatio
        }
        set{
            __imageAspectRatio = newValue
            imageHeightConstraint.constant = round(imageWidthConstraint.constant * __imageAspectRatio)
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Content inset for image view and caption
    public var contentEdgeInset:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(imageTopConstraint.constant, imageLeftConstraint.constant, captionBottomConstraint.constant, imageRightConstraint.constant)
        }
        set{
            imageTopConstraint.constant = newValue.top
            imageLeftConstraint.constant = newValue.left
            imageRightConstraint.constant = newValue.right
            captionBottomConstraint.constant = newValue.bottom
            
            imageWidthConstraint.constant = preferredWidth - imageLeftConstraint.constant - imageRightConstraint.constant
            imageHeightConstraint.constant = round(imageWidthConstraint.constant * imageAspectRatio)
            caption.preferredMaxLayoutWidth = imageWidthConstraint.constant
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Controls the spacing between the caption and the image
    public var captionSpacing:CGFloat{
        get{
            return captionTopConstraint.constant
        }
        set{
            captionTopConstraint.constant = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBOutlet weak private var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var captionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var captionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageLeftConstraint: NSLayoutConstraint!
    private var __imageAspectRatio:CGFloat = 0.75
    
    override public func initialize(){
        caption.setDefaultDescriptionStyling()
        
        // not ready to constrain height yet, set to 0 to get rid of
        imageHeightConstraint.constant = 0
        imageView.delegate = self
    }
    
    override public func update(card:Card) {
        
        var imageUrl:NSURL?
        
        switch(card.type){
        case .Article:
            let articleCard = card as! ArticleCard
            imageUrl = articleCard.primaryImageURL
            caption.text = articleCard.abstractContent
        case .Summary:
            let summaryCard = card as! SummaryCard
            imageUrl = summaryCard.primaryImageURL
            caption.text = summaryCard.abstractContent
        case .Unknown, .Video, .Image:
            imageUrl = nil
        }
        
        // download image
        if imageUrl != nil {
            imageView.setImageWithURL(imageUrl!, mode:.ScaleAspectFill)
        }
    }
    
    override public func adjustForPreferredWidth(cardWidth: CGFloat) {
        imageWidthConstraint.constant = cardWidth - imageLeftConstraint.constant - imageRightConstraint.constant
        imageHeightConstraint.constant = round(imageWidthConstraint.constant * imageAspectRatio)
        caption.preferredMaxLayoutWidth = imageWidthConstraint.constant
        invalidateIntrinsicContentSize()
    }
    
    override public func intrinsicContentSize() -> CGSize {
        let size =  CGSizeMake(preferredWidth, optimizedHeight(preferredWidth))
        return size
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        
        height += imageTopConstraint.constant
        height += imageHeightConstraint.constant
        height += captionTopConstraint.constant
        
        height += Utilities.fittedHeightForLabel(caption, labelWidth: imageWidthConstraint.constant)
        
        height += captionBottomConstraint.constant
        return round(height)
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