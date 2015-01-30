//
//  TallReadMoreCardFooter.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class ReadMoreFooter: CardViewElement {
    
    public var readMoreButton:UIButton!
    
    public var readMoreButtonOffset:UIOffset!{
        get{
            return UIOffset(horizontal: leftConstraint.constant, vertical: verticalCenterConstraint.constant)
        }
        set{
            verticalCenterConstraint.constant = newValue.vertical
            leftConstraint.constant = newValue.horizontal
        }
    }
    
    private var verticalCenterConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    
    override public func initializeElement() {
        readMoreButton = UIButton.defaultReadMoreButton()
        addSubview(readMoreButton!)
        
        verticalCenterConstraint = readMoreButton.verticallyCenterToSuperView(0)
        leftConstraint = readMoreButton.constrainLeftToSuperView(10)
        
        readMoreButton.addTarget(self, action: "readMoreButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return 44
    }
    
    func readMoreButtonTapped(){
        cardView.delegate?.cardViewRequestedAction?(cardView, action: CardViewAction(type: .Maximize, parameters: nil))
    }
}