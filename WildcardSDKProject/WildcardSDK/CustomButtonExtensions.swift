//
//  CustomButtons.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/16/15.
//
//

import Foundation

extension UIButton {
    class func defaultViewOnWebButton() -> UIButton{
        let viewOnWebButton = UIButton(type: UIButtonType.Custom)
        viewOnWebButton.styleAsExternalLink("VIEW ON WEB")
        return viewOnWebButton
    }
    
    func styleAsExternalLink(text:String){
        
        let buttonTitle = NSMutableAttributedString(string: text)
        buttonTitle.setKerning(0.3)
        buttonTitle.setFont(WildcardSDK.cardActionButtonFont)
        buttonTitle.setColor(UIColor.wildcardLightBlue())
        buttonTitle.setUnderline(NSUnderlineStyle.StyleSingle)
        
        let highlightTitle = NSMutableAttributedString(attributedString: buttonTitle)
        highlightTitle.setColor(UIColor.wildcardDarkBlue())
        
        setAttributedTitle(buttonTitle, forState: .Normal)
        setAttributedTitle(highlightTitle, forState: .Highlighted)
    }
    
    class func defaultReadMoreButton()->UIButton{
        
        let readMoreButton = UIButton(type: UIButtonType.Custom)
        readMoreButton.setBackgroundImage(UIImage.loadFrameworkImage("borderedButtonBackground"), forState: UIControlState.Normal)
        readMoreButton.setBackgroundImage(UIImage.loadFrameworkImage("borderedButtonBackgroundTapped"), forState: UIControlState.Highlighted)
        readMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        let buttonTitle = NSMutableAttributedString(string: "READ MORE")
        buttonTitle.setFont(WildcardSDK.cardActionButtonFont)
        buttonTitle.setColor(UIColor.wildcardLightBlue())
        buttonTitle.setKerning(0.3)
        
        let highlightedTitle = NSMutableAttributedString(attributedString: buttonTitle)
        highlightedTitle.setColor(UIColor.wildcardDarkBlue())
        
        readMoreButton.setAttributedTitle(buttonTitle, forState: .Normal)
        readMoreButton.setAttributedTitle(highlightedTitle, forState: .Highlighted)
        readMoreButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        
        return readMoreButton
    }
}