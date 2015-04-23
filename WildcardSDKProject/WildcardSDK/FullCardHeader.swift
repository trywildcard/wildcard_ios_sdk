//
//  FullCardHeader.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

@objc
public class FullCardHeader : CardViewElement
{
    /// Use this to change the vertical spacing between the kicker and title
    public var kickerSpacing:CGFloat{
        get{
            return kickerToTitleSpacing.constant
        }
        set{
            kickerToTitleSpacing.constant = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Content insets of card card content
    public var contentEdgeInset:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(kickerTopConstraint.constant, titleLeadingConstraint.constant, titleBottomConstraint.constant, titleTrailingConstraint.constant)
        }
        set{
            kickerTopConstraint.constant = newValue.top
            titleLeadingConstraint.constant = newValue.left
            titleTrailingConstraint.constant = newValue.right
            titleBottomConstraint.constant = newValue.bottom
            adjustLabelLayoutWidths()
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBOutlet weak var logo: WCImageView!
    @IBOutlet weak public var kicker: UILabel!
    @IBOutlet weak public var title: UILabel!
    public var hairline:UIView!
    
    // MARK: Private
    @IBOutlet weak private var kickerToTitleSpacing: NSLayoutConstraint!
    @IBOutlet weak private var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var kickerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleLeadingConstraint: NSLayoutConstraint!
    
    override public func initialize() {
        logo.layer.cornerRadius = 3.0
        logo.layer.masksToBounds = true
        kicker.setDefaultKickerStyling()
        title.setDefaultTitleStyling()
        hairline = addBottomBorderWithWidth(1.0, color: UIColor.wildcardBackgroundGray())
        contentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 45)
    }
    
    override public func adjustForPreferredWidth(cardWidth: CGFloat) {
        adjustLabelLayoutWidths()
    }
    
    override public func update(card:Card) {
        
        switch(card.type){
        case .Article:
            let articleCard = card as! ArticleCard
            kicker.text = articleCard.creator.name
            title.text = articleCard.title
            if let url = articleCard.creator.favicon{
                logo.setImageWithURL(url,mode:.ScaleToFill)
            }
        case .Summary:
            let summaryCard = card as! SummaryCard
            kicker.text = summaryCard.webUrl.host
            title.text = summaryCard.title
        case .Video:
            let videoCard = card as! VideoCard
            kicker.text = videoCard.webUrl.host
            title.text = videoCard.title
            if let url = videoCard.creator.favicon{
                logo.setImageWithURL(url,mode:.ScaleToFill)
            }
        case .Image:
            let imageCard = card as! ImageCard
            kicker.text = imageCard.creator.name
            title.text = imageCard.title
            if let url = imageCard.creator.favicon{
                logo.setImageWithURL(url,mode:.ScaleToFill)
            }
        case .Unknown:
            title.text = "Unknown Card Type"
            kicker.text = "Unknown Card Type"
        }
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        
        var height:CGFloat = 0
        height += kickerTopConstraint.constant
        height += kicker.font.lineHeight
        height += kickerToTitleSpacing.constant
        
        height += Utilities.fittedHeightForLabel(title, labelWidth: cardWidth - titleLeadingConstraint.constant - titleTrailingConstraint.constant)
  
        height += titleBottomConstraint.constant
        
        return round(height)
    }
    
    private func adjustLabelLayoutWidths(){
        // preferred width affects preferred layout widths of labels
        title.preferredMaxLayoutWidth = preferredWidth - titleLeadingConstraint.constant - titleTrailingConstraint.constant
        kicker.preferredMaxLayoutWidth = preferredWidth - titleLeadingConstraint.constant - titleTrailingConstraint.constant
    }
    
}