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
public class ImageAndCaptionBody : CardViewElement{
    
    @IBOutlet weak public var imageView: WCImageView!
    @IBOutlet weak public var caption: UILabel!
    public var imageAspectRatio:CGFloat = 0.75
    
    /**
    Content inset which includes the image view and caption
    */
    public var contentEdgeInset:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(imageTopConstraint.constant, imageLeftConstraint.constant, captionBottomConstraint.constant, imageRightConstraint.constant)
        }
        set{
            imageTopConstraint.constant = newValue.top
            imageLeftConstraint.constant = newValue.left
            imageRightConstraint.constant = newValue.right
            captionBottomConstraint.constant = newValue.bottom
        }
    }
    
    /// Controls the spacing between the caption and the image
    public var captionSpacing:CGFloat!{
        get{
            return captionTopConstraint.constant
        }
        set{
            captionTopConstraint.constant = newValue
        }
    }
    
    @IBOutlet weak private var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var captionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var captionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageLeftConstraint: NSLayoutConstraint!
    
    override public func initializeElement(){
        caption.font = WildcardSDK.cardDescriptionFont
        caption.textColor = UIColor.wildcardMediaBodyColor()
        
        // not ready to constrain height yet, set to 0 to get rid of
        imageHeightConstraint.constant = 0
        imageView.backgroundColor = UIColor.wildcardBackgroundGray()
        imageView.layer.cornerRadius = 2.0
        imageView.layer.masksToBounds = true
    }
    
    override public func update() {
        super.update()
        
        var imageUrl:NSURL?
        
        switch(cardView.backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            imageUrl = articleCard.primaryImageURL
            caption.text = articleCard.abstractContent
        case .Summary:
            let summaryCard = cardView.backingCard as SummaryCard
            imageUrl = summaryCard.imageUrl
            caption.text = summaryCard.abstractContent
        case .Unknown:
            imageUrl = nil
        }
        
        // download image
        if imageUrl != nil {
            imageView.setImageWithURL(imageUrl!, mode:.ScaleAspectFill)
        }
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        
        let contentInsets = contentEdgeInset
        
        let imageWidth = cardWidth - contentInsets.left - contentInsets.right
        let imageHeight:CGFloat = round(imageAspectRatio * imageWidth)
        height += contentInsets.top
        height += imageHeight
        height += captionTopConstraint.constant
        
        // how tall would the caption need to be for this width
        let expectedCaptionSize = caption.sizeThatFits(CGSizeMake(cardWidth - contentInsets.left - contentInsets.right, CGFloat.max))
        height += ceil(expectedCaptionSize.height)
        height += contentEdgeInset.bottom
        return height
    }
    
    override public func cardViewFinishedLayout() {
        // once the parent card view has finished laying out, we can constrain the height of image properly
        imageHeightConstraint.constant = round(imageAspectRatio * imageView.frame.width)
    }
}