//
//  FullCardHeader.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class FullCardHeader :CardViewElement
{
    /**
    Spacing between kicker and the title
    */
    public var kickerSpacing:CGFloat!{
        get{
            return kickerTitleVerticalSpacing.constant
        }
        set{
            kickerTitleVerticalSpacing.constant = newValue
        }
    }
    
    /**
    Custom offset adjustments to the title label
    */
    public var titleOffset:UIOffset!{
        get{
            return UIOffset(horizontal: titleLeadingConstraint.constant, vertical: titleTitleTopConstraint.constant)
        }
        set{
            titleTitleTopConstraint.constant = newValue.vertical
            titleLeadingConstraint.constant = newValue.horizontal
        }
    }
    
    @IBOutlet weak public var logo: UIImageView!
    @IBOutlet weak public var kicker: UILabel!
    @IBOutlet weak public var title: UILabel!
    public var bottomHairline:UIView!
    
    @IBOutlet weak var titleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var kickerTitleVerticalSpacing: NSLayoutConstraint!
    
    override func initializeElement() {
        logo.layer.cornerRadius = 4.0
        logo.layer.masksToBounds = true
        kicker.font = UIFont.defaultCardKickerFont()
        kicker.textColor = UIColor.wildcardMediumGray()
        title.font = UIFont.defaultCardTitleFont()
        title.textColor = UIColor.wildcardDarkBlue()
        bottomHairline = addBottomBorderWithWidth(1.0, color: UIColor.wildcardBackgroundGray())
    }
    
    override func update() {
        
        switch(backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            kicker.text = articleCard.publisher.name
            title.text = articleCard.title
            if let url = articleCard.publisher.smallLogoUrl{
                logo.downloadImageWithURL(url, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.logo.image = image!
                    }
                })
            }
        case .Summary:
            let summaryCard = cardView.backingCard as SummaryCard
            kicker.text = summaryCard.webUrl.host
            title.text = summaryCard.title
            logo.image = UIImage.loadFrameworkImage("wildcardSmallLogo")
        case .Unknown:
            title.text = "Unknown Card Type"
            kicker.text = "Unknown Card Type"
            logo.image = UIImage.loadFrameworkImage("wildcardSmallLogo")
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        
        var height:CGFloat = 0
        height += titleOffset.vertical
        
        // how tall would the title need to be for this width
        let expectedTitleSize = title.sizeThatFits(CGSizeMake(cardWidth - titleLeadingConstraint.constant - titleTrailingConstraint.constant, CGFloat.max))
        height += ceil(expectedTitleSize.height)
  
        // bottom margin below the title
        height += 10
        return height
    }
    
}