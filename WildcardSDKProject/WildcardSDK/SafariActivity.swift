//
//  SafariActivity.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/30/15.
//
//

import Foundation
import UIKit

class SafariActivity : UIActivity
{
    
    var activityItems:[AnyObject]?
    
    override func activityType() -> String? {
        return "wildcard.openInSafari"
    }
    
    override func activityTitle() -> String? {
        return "Open in Safari"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage.loadFrameworkImage("safariIcon")
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for object in activityItems{
            if object is NSURL {
                return true
            }
        }
        return false
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        self.activityItems = activityItems
    }
    
    override func performActivity() {
        var opened = false
        
        if let items = activityItems{
            for object in items{
                if let url = object as? NSURL{
                    if(UIApplication.sharedApplication().canOpenURL(url)){
                        opened = UIApplication.sharedApplication().openURL(url)
                    }else{
                        opened = false
                    }
                }
            }
        }
        
        activityDidFinish(opened)
    }
}
