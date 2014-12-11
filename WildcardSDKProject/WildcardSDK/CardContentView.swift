//
//  CardContentView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation
import UIKit

public class CardContentView : UIView
{
    // MARK: Class
    class var DEFAULT_HORIZONTAL_MARGIN :CGFloat{
        return 15.0
    }
    class var DEFAULT_HORIZONTAL_PADDING :CGFloat{
        return 15.0
    }
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> CardContentView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? CardContentView
    }
    
    var associatedLayout:CardLayout?
    
    // MARK: Instance
    
    // Update the card content view with card data
    func updateViewForCard(card:Card){
        // override
    }
    
    // Return a best fit bounds given the current state of the content view
    func optimalBounds()->CGRect{
        // override
        return CGRectZero
    }
    
    class func generateContentViewFromLayout(layout:CardLayout)->CardContentView{
        var newCardContentView:CardContentView!
        
        switch(layout){
            
        case .WebLinkCardPortraitImageSmallFloatLeft:
            newCardContentView = CardContentView.loadFromNibNamed("WebLinkCardPortraitImageSmallFloatLeft")!
        case .WebLinkCardPortraitDefault:
            newCardContentView = CardContentView.loadFromNibNamed("WebLinkCardPortraitDefault")!
        case .WebLinkCardPortraitImageFull:
            newCardContentView = CardContentView.loadFromNibNamed("WebLinkCardPortraitImageFull")!
        default:
            newCardContentView = CardContentView.loadFromNibNamed("BareCard")!
        }
        
        // After we load the template, set bounds to whatever we think is optimal
       // newCardContentView.bounds = newCardContentView.optimalBounds()
        return newCardContentView
    }
}