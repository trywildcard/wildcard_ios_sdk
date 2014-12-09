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
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> CardContentView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? CardContentView
    }
    
    func updateViewForCard(card:Card){
        // override
    }
}