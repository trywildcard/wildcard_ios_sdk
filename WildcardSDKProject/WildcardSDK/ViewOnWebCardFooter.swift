//
//  ViewOnWebFooter.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class ViewOnWebCardFooter: CardViewElement {
    
    var viewOnWebButton:UIButton?
    
    override func initializeElement() {
        viewOnWebButton = UIButton(frame: CGRectZero)
        addSubview(viewOnWebButton!)
        viewOnWebButton?.verticallyCenterToSuperView(1)
        
        addConstraint(NSLayoutConstraint(item: viewOnWebButton!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 10))
        viewOnWebButton?.setBackgroundImage(UIImage(named: "viewOnWebButton"), forState: UIControlState.Normal)
        
        addTopBorderWithWidth(0.5, color: UIColor.wildcardBackgroundGray())
    }
    
    override class func optimizedHeight(cardWidth:CGFloat, card:Card)->CGFloat{
        return 40.5
    }
}