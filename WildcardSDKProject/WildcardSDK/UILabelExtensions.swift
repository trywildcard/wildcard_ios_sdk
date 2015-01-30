//
//  UILabelExtensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/29/15.
//
//

import Foundation

extension UILabel{
    
    func setRequiredNumberOfLines(maxHeight:CGFloat){
        if let labelText = text{
            let height = Utilities.heightRequiredForText(labelText, lineHeight: font.lineHeight, font: font, width: frame.width, maxHeight:maxHeight)
            let rawValue:Float = roundf(Float(height) / Float(font.lineHeight));
            numberOfLines = Int(rawValue)
        }else{
            numberOfLines = 0
        }
    }
    
}