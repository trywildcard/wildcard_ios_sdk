//
//  BareBonesCardBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class PlaceholderCardBody : CardViewElement {
    
    var titleLabel:UILabel!
    
    override func initializeElement(){
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.Center
        addSubview(titleLabel)
        titleLabel.verticallyCenterToSuperView(0)
        titleLabel.text = "Placeholder"
        titleLabel.constrainLeftToSuperView(15)
        titleLabel.constrainRightToSuperView(15)
    }
}