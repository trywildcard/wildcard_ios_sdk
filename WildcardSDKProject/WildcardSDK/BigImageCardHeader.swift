//
//  BigImageCardHeader.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/24/15.
//
//

import Foundation

@objc
public class BigImageCardHeader : CardViewElement
{
    @IBOutlet weak public var title: UILabel!
    @IBOutlet weak public var imageView: UIImageView!
    @IBOutlet weak public var kicker: UILabel!
    public var hairline:UIView!
    
    public var contentEdgeInset:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(imageViewTopConstraint.constant, titleLeadingConstraint.constant, bottomPadding, imageViewRightConstraint.constant)
        }
        set{
            imageViewTopConstraint.constant = newValue.top
            titleLeadingConstraint.constant = newValue.left
            imageViewRightConstraint.constant = newValue.right
            bottomPadding = newValue.bottom
        }
    }
    
    @IBOutlet weak private var imageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageViewHeightConstraint: NSLayoutConstraint!
    private var bottomPadding:CGFloat = 10
    
    override func initializeElement() {
        
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        kicker.font =  WildcardSDK.cardKickerFont
        kicker.textColor = UIColor.wildcardMediumGray()
        title.font = WildcardSDK.cardTitleFont
        title.textColor = UIColor.wildcardDarkBlue()
        hairline = addBottomBorderWithWidth(1.0, color: UIColor.wildcardBackgroundGray())
    }
    
    override func update() {
        switch(backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            kicker.text = articleCard.publisher.name
            title.text = articleCard.title
            if let url = articleCard.primaryImageURL {
                imageView.downloadImageWithURL(url, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.imageView.image = image!
                    }
                })
            }
        case .Summary:
            let summaryCard = cardView.backingCard as SummaryCard
            kicker.text = summaryCard.webUrl.host
            title.text = summaryCard.title
            if let url = summaryCard.imageUrl {
                imageView.downloadImageWithURL(url, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.imageView.image = image!
                    }
                })
            }
        case .Unknown:
            title.text = "Unknown Card Type"
            kicker.text = "Unknown Card Type"
            imageView.image = UIImage.loadFrameworkImage("wildcardSmallLogo")
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return imageViewTopConstraint.constant + imageViewHeightConstraint.constant + bottomPadding;
    }
}