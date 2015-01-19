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
        var viewOnWebButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        viewOnWebButton.styleAsExternalLink("VIEW ON WEB")
        return viewOnWebButton
    }
    
    func styleAsExternalLink(text:String){
        
        var buttonTitle = NSMutableAttributedString(string: text)
        buttonTitle.setKerning(0.3)
        buttonTitle.setFont(UIFont.defaultCardActionButton())
        buttonTitle.setColor(UIColor.wildcardLightBlue())
        buttonTitle.setUnderline(NSUnderlineStyle.StyleSingle)
        
        var highlightTitle = NSMutableAttributedString(attributedString: buttonTitle)
        highlightTitle.setColor(UIColor.wildcardDarkBlue())
        
        setAttributedTitle(buttonTitle, forState: .Normal)
        setAttributedTitle(highlightTitle, forState: .Highlighted)
    }
    
    class func defaultReadMoreButton()->UIButton{
        
        var readMoreButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        readMoreButton.setBackgroundImage(UIImage.loadFrameworkImage("borderedButtonBackground"), forState: UIControlState.Normal)
        readMoreButton.setBackgroundImage(UIImage.loadFrameworkImage("borderedButtonBackgroundTapped"), forState: UIControlState.Highlighted)
        readMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        let buttonTitle = NSMutableAttributedString(string: "READ MORE")
        buttonTitle.setFont(UIFont.defaultCardActionButton())
        buttonTitle.setColor(UIColor.wildcardLightBlue())
        buttonTitle.setKerning(0.3)
        
        let highlightedTitle = NSMutableAttributedString(attributedString: buttonTitle)
        highlightedTitle.setColor(UIColor.wildcardDarkBlue())
        
        readMoreButton.setAttributedTitle(buttonTitle, forState: .Normal)
        readMoreButton.setAttributedTitle(highlightedTitle, forState: .Highlighted)
        readMoreButton.constrainWidth(90, height:25)
        
        return readMoreButton
    }
    
    
}