//
//  TallReadMoreCardFooter.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class TallReadMoreFooter: CardViewElement {
    
    var readMoreButton:UIButton!
    
    override func initializeElement() {
        readMoreButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        addSubview(readMoreButton!)
        
        readMoreButton.setBackgroundImage(UIImage(named: "borderedButtonBackground"), forState: UIControlState.Normal)
        readMoreButton.setBackgroundImage(UIImage(named: "borderedButtonBackgroundTapped"), forState: UIControlState.Highlighted)
        readMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        let buttonTitle = NSMutableAttributedString(string: "READ MORE")
        buttonTitle.setFont(UIFont.wildcardStandardButtonFont())
        buttonTitle.setColor(UIColor.wildcardLightBlue())
        buttonTitle.setKerning(0.4)
        readMoreButton.setAttributedTitle(buttonTitle, forState: UIControlState.Normal)
        
        let highlightedTitle = NSMutableAttributedString(attributedString: buttonTitle)
        highlightedTitle.setColor(UIColor.wildcardDarkBlue())
        readMoreButton.setAttributedTitle(highlightedTitle, forState: UIControlState.Highlighted)
        
        readMoreButton.titleEdgeInsets = UIEdgeInsetsMake(-2, 1, 0, 0);
        readMoreButton.verticallyCenterToSuperView(0)
        addConstraint(NSLayoutConstraint(item:readMoreButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20))
        readMoreButton.constrainWidth(98, andHeight: 25)
        
        readMoreButton.addTarget(self, action: "readMoreButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func updateForCard(card: Card) {
        super.updateForCard(card)
        
    }
    
    override class func optimizedHeight(cardWidth:CGFloat, card:Card)->CGFloat{
        return 65
    }
    
    func readMoreButtonTapped(){
        delegate?.cardViewElementRequestedReadMore?()
    }
}