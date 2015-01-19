//
//  ImageWithCaption.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/16/15.
//
//

import Foundation

public class ImageAndCaptionBody : CardViewElement{
    
    @IBOutlet weak public var imageView: UIImageView!
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
    
    @IBOutlet weak private var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var captionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var captionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageLeftConstraint: NSLayoutConstraint!
    
    override func initializeElement(){
        caption.font = UIFont.defaultCardDescriptionFont()
        
        // not ready to constrain height yet, set to 0 to get rid of
        imageHeightConstraint.constant = 0
    }
    
    override func update() {
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
            caption.text = summaryCard.description
        case .Unknown:
            imageUrl = nil
        }
        
        // download image
        if imageUrl != nil {
            imageView.downloadImageWithURL(imageUrl!, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                if(image != nil){
                    self.imageView.image = image
                    self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
                }else{
                    self.imageView.image = UIImage.loadFrameworkImage("noImage")
                    self.imageView.contentMode = UIViewContentMode.Center
                }
            })
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        
        let contentInsets = contentEdgeInset
        
        let imageWidth = cardWidth - contentInsets.left - contentInsets.right
        let imageHeight:CGFloat = imageAspectRatio * imageWidth
        height += contentInsets.top
        height += imageHeight
        height += captionTopConstraint.constant
        
        // how tall would the caption need to be for this width
        let expectedCaptionSize = caption.sizeThatFits(CGSizeMake(cardWidth - contentInsets.left - contentInsets.right, CGFloat.max))
        height += expectedCaptionSize.height
        height += contentEdgeInset.bottom
        return height
    }
    
    override func cardViewFinishedLayout() {
        // once the parent card view has finished laying out, we can constrain the height of image properly
        imageHeightConstraint.constant = imageAspectRatio * imageView.frame.width
    }
}