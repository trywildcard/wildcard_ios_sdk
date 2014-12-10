//
//  CardContentView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation
import UIKit

class CardContentView : UIView
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
    func optimalBounds()->CGSize{
        // override
        return CGSizeZero
    }
}