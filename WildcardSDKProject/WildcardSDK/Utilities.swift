//
//  Utilities.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation

class Utilities{
    class func printFontFamilies()
    {
        for name in UIFont.familyNames()
        {
            if let nameString = name as? String{
                let names = UIFont.fontNamesForFamilyName(nameString)
                println(nameString)
                println(names)
            }
        }
    }
    
    class func heightRequiredForText(text:String, lineHeight:CGFloat, font:UIFont, width:CGFloat, maxHeight:CGFloat)->CGFloat{
        let nsStr = NSString(string: text)
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
    
    
    class func heightRequiredForText(text:String, lineHeight:CGFloat, font:UIFont, width:CGFloat)->CGFloat{
        return Utilities.heightRequiredForText(text, lineHeight: lineHeight, font: font, width: width, maxHeight: CGFloat.max)
    }
    
    class func sizeFromDataSource(datasource:CardViewDataSource)->CGSize{
        let width = datasource.widthForCard()
        var height:CGFloat = 0
        if let headerHeight = datasource.heightForCardHeader?(){
            height += headerHeight
        }
        if let footerHeight = datasource.heightForCardFooter?(){
            height += footerHeight
        }
        height += datasource.heightForCardBody()
        return CGSizeMake(width, height)
    }
    
}