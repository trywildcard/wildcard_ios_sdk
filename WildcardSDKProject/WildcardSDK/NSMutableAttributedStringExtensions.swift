//
//  NSMutableAttributedStringExtensions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation


extension NSMutableAttributedString{
    
    func setLineHeight(height:CGFloat){
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight =  height
        paragraphStyle.maximumLineHeight =  height
        
        self.addAttribute(NSParagraphStyleAttributeName,
            value: paragraphStyle,
            range: NSMakeRange(0, countElements(self.string)))
    }
    
    func setFont(font:UIFont){
        self.addAttribute(NSFontAttributeName,
            value: font,
            range: NSMakeRange(0, countElements(self.string)))
    }
    
    func setColor(color:UIColor){
        self.addAttribute(NSForegroundColorAttributeName,
            value: color,
            range: NSMakeRange(0, countElements(self.string)))
    }
    
    func setKerning(kerning:Float){
        self.addAttribute(NSKernAttributeName, value: NSNumber(float:kerning), range: NSMakeRange(0, countElements(self.string)))
        
    }
    
    func setUnderline(style:NSUnderlineStyle){
        self.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(long:style.rawValue), range: NSMakeRange(0,countElements(self.string)))
    }
}

