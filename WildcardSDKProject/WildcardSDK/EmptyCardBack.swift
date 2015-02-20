//
//  EmptyCardBack.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class EmptyCardBack : CardViewElement {
    
    var titleLabel:UILabel!
    
    override func initialize() {
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = NSTextAlignment.Center
        addSubview(titleLabel)
        titleLabel.verticallyCenterToSuperView(0)
        titleLabel.horizontallyCenterToSuperView(0)
        titleLabel.font = WildcardSDK.cardTitleFont
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "The Back!"
        backgroundColor = UIColor.wildcardDarkBlue()
    }
}