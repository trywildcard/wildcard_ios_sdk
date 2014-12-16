//
//  UILabelExtensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

extension UILabel{
    func setAsCardHeaderWithText(text:String?){
        if(text != nil){
            let mutableString = NSMutableAttributedString(string: text!)
            mutableString.setLineHeight(UIFont.wildcardStandardHeaderFontLineHeight())
            mutableString.setColor(UIColor.wildcardDarkBlue())
            mutableString.setFont(UIFont.wildcardStandardHeaderFont())
            attributedText = mutableString
        }
    }
    
    func setAsCardSubHeaderWithText(text:String?){
        if(text != nil){
            let mutableString = NSMutableAttributedString(string: text!)
            mutableString.setLineHeight(UIFont.wildcardStandardSubHeaderFontLineHeight())
            mutableString.setColor(UIColor.wildcardMediumGray())
            mutableString.setFont(UIFont.wildcardStandardSubHeaderFont())
            attributedText = mutableString
        }
    }
    
    func setAsCardMediaBodyWithText(text:String?){
        if(text != nil){
            let mutableString = NSMutableAttributedString(string: text!)
            mutableString.setLineHeight(UIFont.wildcardStandardMediaBodyFontLineHeight())
            mutableString.setColor(UIColor.wildcardMediumGray())
            mutableString.setFont(UIFont.wildcardStandardMediaBodyFont())
            attributedText = mutableString
        }
    }
}