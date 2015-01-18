//
//  OneLineCardHeader.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

/**
The most basic Card Header consisting of a 1 line title label and a logo
*/
public class OneLineCardHeader : CardViewElement {
    
    public var title:UILabel!
    public var titleOffset:UIOffset!{
        get{
            return UIOffset(horizontal: titleVerticalConstraint.constant, vertical: titleLeftConstraint.constant)
        }
        set{
            titleVerticalConstraint.constant = newValue.vertical
            titleLeftConstraint.constant = newValue.horizontal
        }
    }
    public var bottomHairline:UIView!
    public var logo:UIImageView!
    
    private var titleVerticalConstraint:NSLayoutConstraint!
    private var titleLeftConstraint:NSLayoutConstraint!
    private var titleRightConstraint:NSLayoutConstraint!
    
    override func initializeElement() {
        
        backgroundColor = UIColor.whiteColor()
        
        title = UILabel(frame: CGRectZero)
        title.numberOfLines = 1
        title.textAlignment = NSTextAlignment.Left
        title.font = UIFont.defaultCardTitleFont()
        title.textColor = UIColor.wildcardDarkBlue()
        addSubview(title)
        titleVerticalConstraint = title.verticallyCenterToSuperView(0)
        titleLeftConstraint = title.constrainLeftToSuperView(10)
        titleRightConstraint = title.constrainRightToSuperView(45)
        
        logo = UIImageView(frame: CGRectMake(0, 0, 25, 25))
        logo.constrainWidth(25, height: 25)
        logo.layer.cornerRadius = 3.0
        logo.layer.masksToBounds = true
        addSubview(logo)
        logo.constrainRightToSuperView(10)
        logo.constrainTopToSuperView(7.5)
        
        bottomHairline = addBottomBorderWithWidth(1.0, color: UIColor.wildcardBackgroundGray())
    }
    
    override func update() {
        
        switch(backingCard.type){
        case .WCCardTypeArticle:
            let articleCard = cardView.backingCard as ArticleCard
            title.text = articleCard.title
            if let url = articleCard.publisher.smallLogoUrl{
                logo.downloadImageWithURL(url, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.logo.image = image!
                    }
                })
            }
        case .WCCardTypeSummary:
            let summaryCard = cardView.backingCard as SummaryCard
            title.text = summaryCard.title
            logo.image = UIImage(named: "wildcardSmallLogo")
        case .WCCardTypeUnknown:
            title.text = "Unknown Card Type!"
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return 41
    }
}