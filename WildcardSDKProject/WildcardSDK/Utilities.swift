//
//  Utilities.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation

/// Public Bag of Tricks
public class Utilities{
    
    // MARK: Public
    
    /// Prints the font families available
    public class func printFontFamilies(){
        for name in UIFont.familyNames()
        {
            println("Font family: \(name)")
            if let nameString = name as? String{
                let names = UIFont.fontNamesForFamilyName(nameString)
                println(names)
            }
        }
    }
    
    /// Get the height required for a specific text string, with a max height
    public class func heightRequiredForText(text:String?, lineHeight:CGFloat, font:UIFont, width:CGFloat, maxHeight:CGFloat)->CGFloat{
        if(text == nil){
            return 0
        }else{
            let nsStr = NSString(string: text!)
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
            
            var attributesDictionary:[NSObject:AnyObject] =
            [NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName:font]
            
            let bounds =
            nsStr.boundingRectWithSize(CGSizeMake(width,
                maxHeight),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: attributesDictionary,
                context: nil)
            return bounds.size.height;
        }
    }
    
    /// Get the height required for a specific text string with unbounded height
    public class func heightRequiredForText(text:String?, lineHeight:CGFloat, font:UIFont, width:CGFloat)->CGFloat{
        return Utilities.heightRequiredForText(text, lineHeight: lineHeight, font: font, width: width, maxHeight: CGFloat.max)
    }
}