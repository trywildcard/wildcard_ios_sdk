//
//  UILabelExtensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/29/15.
//
//

import Foundation

extension UILabel{
    
    func setRequiredNumberOfLines(width:CGFloat, maxHeight:CGFloat){
        if let labelText = text{
            let height = Utilities.heightRequiredForText(labelText, lineHeight: font.lineHeight, font: font, width: width, maxHeight:maxHeight)
            let rawValue:Float = roundf(Float(height) / Float(font.lineHeight));
            numberOfLines = Int(rawValue)
        }else{
            numberOfLines = 0
        }
    }
    
    func setDefaultKickerStyling(){
        font =  WildcardSDK.cardKickerFont
        numberOfLines = 1
        textColor = WildcardSDK.cardKickerColor
    }
    
    func setDefaultTitleStyling(){
        font = WildcardSDK.cardTitleFont
        textColor = WildcardSDK.cardTitleColor
    }
    
    func setDefaultDescriptionStyling(){
        font = WildcardSDK.cardDescriptionFont
        textColor = WildcardSDK.cardDescriptionColor
    }
    
}