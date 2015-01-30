//
//  FullCardHeader.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

@objc
public class FullCardHeader :CardViewElement
{
    /// Controls the spacing between the kicker and the title
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
    
    @IBOutlet weak var logo: WCImageView!
    @IBOutlet weak public var kicker: UILabel!
    @IBOutlet weak public var title: UILabel!
    public var hairline:UIView!
    
    @IBOutlet weak private var titleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var kickerTitleVerticalSpacing: NSLayoutConstraint!
    
    override public func initializeElement() {
        logo.layer.cornerRadius = 4.0
        logo.layer.masksToBounds = true
        kicker.font =  WildcardSDK.cardKickerFont
        kicker.textColor = UIColor.wildcardMediumGray()
        title.font = WildcardSDK.cardTitleFont
        title.textColor = UIColor.wildcardDarkBlue()
        hairline = addBottomBorderWithWidth(1.0, color: UIColor.wildcardBackgroundGray())
    }
    
    override public func update() {
        
        switch(backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            kicker.text = articleCard.publisher.name
            title.text = articleCard.title
            if let url = articleCard.publisher.smallLogoUrl{
                logo.setImageWithURL(url,mode:.ScaleToFill)
            }
        case .Summary:
            let summaryCard = cardView.backingCard as SummaryCard
            kicker.text = summaryCard.webUrl.host
            title.text = summaryCard.title
        case .Unknown:
            title.text = "Unknown Card Type"
            kicker.text = "Unknown Card Type"
        }
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        
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