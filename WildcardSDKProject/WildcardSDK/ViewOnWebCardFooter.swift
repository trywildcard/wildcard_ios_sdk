//
//  ViewOnWebFooter.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class ViewOnWebCardFooter: CardViewElement {
    
    public var viewOnWebButton:UIButton!
    public var shareButton:UIButton!
    public var hairline:UIView!
    
    public var viewOnWebButtonOffset:UIOffset!{
        get{
            return UIOffset(horizontal: leftConstraint.constant, vertical: verticalCenterConstraint.constant)
        }
        set{
            verticalCenterConstraint.constant = newValue.vertical
            leftConstraint.constant = newValue.horizontal
            shareButtonRightConstraint.constant = newValue.horizontal
        }
    }
    
    private var verticalCenterConstraint:NSLayoutConstraint!
    private var leftConstraint:NSLayoutConstraint!
    private var shareButtonRightConstraint:NSLayoutConstraint!
    
    override func initializeElement() {
        viewOnWebButton = UIButton.defaultViewOnWebButton()
        addSubview(viewOnWebButton!)
        verticalCenterConstraint = viewOnWebButton?.verticallyCenterToSuperView(0)
        leftConstraint = viewOnWebButton?.constrainLeftToSuperView(10)
        hairline = addTopBorderWithWidth(0.5, color: UIColor.wildcardBackgroundGray())
        
        shareButton = UIButton(frame: CGRectZero)
        shareButton.tintColor = UIColor.wildcardLightBlue()
        shareButton.setImage(UIImage(named: "shareIcon"), forState: .Normal)
        addSubview(shareButton)
        shareButtonRightConstraint = shareButton.constrainRightToSuperView(10)
        
        addConstraint(NSLayoutConstraint(item: shareButton, attribute: .CenterY, relatedBy: .Equal, toItem: viewOnWebButton, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        shareButton.addTarget(self, action: "shareButtonTapped", forControlEvents: .TouchUpInside)
    }
    
    func shareButtonTapped(){
        Platform.sharedInstance.createWildcardShortLink(cardView.backingCard.webUrl, completion: { (url:NSURL?, error:NSError?) -> Void in
            if let shareUrl = url {
                var parameters = NSMutableDictionary()
                parameters["url"] = shareUrl
                self.cardView.delegate?.cardViewRequestedAction?(self.cardView, action: CardViewAction(type: .Action, parameters: parameters))
            }
        })
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return 44
    }
}