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
    public class var IS_IPAD: Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad
    }
    public class var IS_IPHONE: Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone
    }
    public class var IS_RETINA: Bool {
        return UIScreen.mainScreen().scale >= 2.0
    }
    public class var SCREEN_WIDTH:CGFloat{
        return UIScreen.mainScreen().bounds.size.width;
    }
    public class var SCREEN_HEIGHT:CGFloat{
        return UIScreen.mainScreen().bounds.size.height;
    }
    public class var SCREEN_MAX_LENGTH:CGFloat{
        return max(SCREEN_HEIGHT, SCREEN_WIDTH)
    }
    public class var SCREEN_MAIN_LENGTH:CGFloat{
        return min(SCREEN_HEIGHT, SCREEN_WIDTH)
    }
    public class var IS_IPHONE_4_OR_LESS:Bool{
        return IS_IPHONE && SCREEN_MAX_LENGTH < 568.0
    }
    public class var IS_IPHONE_5:Bool{
        return IS_IPHONE && SCREEN_MAX_LENGTH == 568.0
    }
    public class var IS_IPHONE_6:Bool{
        return IS_IPHONE && SCREEN_MAX_LENGTH == 667.0
    }
    public class var IS_IPHONE_6P:Bool{
        return IS_IPHONE && SCREEN_MAX_LENGTH == 736.0
    }
    
    /// Prints the font families available
    public class func printFontFamilies(){
        for name in UIFont.familyNames()
        {
            print("Font family: \(name)")
            let names = UIFont.fontNamesForFamilyName(name)
            print(names)
        }
    }
    
    /// Get the height required for a specific text string, with a max height
    public class func heightRequiredForText(text:String?, lineHeight:CGFloat, font:UIFont, width:CGFloat, maxHeight:CGFloat)->CGFloat{
        if(text == nil){
            return 0
        }else{
            let nsStr = NSString(string: text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
            
            let attributesDictionary:[String: AnyObject] =
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
    
    /// Gets the fitted height for a label given a specific width
    public class func fittedHeightForLabel(label:UILabel, labelWidth:CGFloat)->CGFloat{
        
        var titleHeight:CGFloat = 0
        if(label.numberOfLines == 0){
            // unbounded height
            titleHeight = Utilities.heightRequiredForText(label.text, lineHeight: label.font.lineHeight, font: label.font, width: labelWidth)
        }else{
            // set number of lines, must cap the height
            let maxHeight:CGFloat = CGFloat(label.numberOfLines) * label.font.lineHeight
            titleHeight = Utilities.heightRequiredForText(label.text, lineHeight: label.font.lineHeight, font: label.font, width: labelWidth, maxHeight:maxHeight)
        }
        return titleHeight
        
    }
}