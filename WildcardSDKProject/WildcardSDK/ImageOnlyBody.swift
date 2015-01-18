//
//  CenteredImageBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class ImageOnlyBody : CardViewElement{
    
    public var image:UIImageView!
    public var imageAspectRatio:CGFloat = 0.75
    public var imageEdgeInsets:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(topConstraint.constant, leftConstraint.constant, bottomConstraint.constant, rightConstraint.constant)
        }
        set{
            topConstraint.constant = newValue.top
            leftConstraint.constant = newValue.left
            rightConstraint.constant = newValue.right
            bottomConstraint.constant = newValue.bottom
        }
    }
    
    private var topConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    private var rightConstraint:NSLayoutConstraint!
    private var bottomConstraint:NSLayoutConstraint!
    
    override func initializeElement(){
        
        image = UIImageView(frame: CGRectZero)
        image.layer.cornerRadius = 2.0
        image.layer.masksToBounds = true
        image.backgroundColor = UIColor.whiteColor()
        addSubview(image)
        
        leftConstraint = image.constrainLeftToSuperView(10)
        rightConstraint = image.constrainRightToSuperView(10)
        topConstraint = image.constrainTopToSuperView(10)
        bottomConstraint = image.constrainBottomToSuperView(10)
    }
    
    override func update() {
        super.update()
        
        var imageUrl:NSURL?
        
        switch(cardView.backingCard.type){
        case .WCCardTypeArticle:
            let articleCard = cardView.backingCard as ArticleCard
            imageUrl = articleCard.primaryImageURL
        case .WCCardTypeSummary:
            let webLinkCard = cardView.backingCard as SummaryCard
            imageUrl = webLinkCard.imageUrl
        case .WCCardTypeUnknown:
            imageUrl = nil
        }
        
        // download image
        if imageUrl != nil {
            image.downloadImageWithURL(imageUrl!, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                if(image != nil){
                    self.image.image = image
                    self.image.contentMode = UIViewContentMode.ScaleToFill
                }else{
                    self.image.image = UIImage(named: "noImage")
                    self.image.contentMode = UIViewContentMode.Center
                }
            })
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        var height:CGFloat = 0.0
        height += topConstraint.constant
        height += bottomConstraint.constant
        height += imageAspectRatio * (cardWidth - leftConstraint.constant - rightConstraint.constant)
        return height
    }
    
}