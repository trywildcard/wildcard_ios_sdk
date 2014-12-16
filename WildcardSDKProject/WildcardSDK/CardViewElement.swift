//
//  CardElement.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation


public class CardViewElement : UIView {
    
    func updateForCard(card:Card){
        // override
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}