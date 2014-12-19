//
//  MediaTextFullWebView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/18/14.
//
//

import Foundation
import WebKit

class MediaTextFullWebView : CardViewElement
{
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var webview: UIWebView!
    
    override func initializeElement() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
    }
    
    override func updateForCard(card: Card) {
        super.updateForCard(card)
        
        if let articleCard = card as? ArticleCard{
            webview?.loadHTMLString(constructFinalHtml(articleCard), baseURL: nil)
        }
    }
  
    @IBAction func closeButtonTapped(sender: AnyObject) {
        delegate?.cardViewElementRequestedToClose?()
    }
    
    func constructFinalHtml(articleCard:ArticleCard)->String{
        var finalHtml = MediaTextFullWebView.webViewReadingCss
        
        finalHtml +=  "<div id=\"customWildcardHeader\">\(articleCard.title)</div>"
        
        let publishedDateFormatter = NSDateFormatter()
        publishedDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss "
        var dateDisplayString:String?
        if let date = articleCard.publicationDate{
            dateDisplayString = publishedDateFormatter.stringFromDate(date)
        }
        
        var bylineDisplay:String?
    
        if let author = articleCard.author {
            if let dateString = dateDisplayString{
                bylineDisplay = String(format: "%@ %@ %@", dateString, "\u{2014}", author)
            }else{
                bylineDisplay = author
            }
        }else if let dateString = dateDisplayString{
            bylineDisplay = dateString
        }
        
        if bylineDisplay != nil{
             finalHtml +=  "<div id=\"customWildcardByline\">\(bylineDisplay!)</div>"
        }
        
        finalHtml += articleCard.html
        
        finalHtml += "<div><center><span class=\"viewMore\"><a id=\"viewOnWeb\" href=\"\(articleCard.webUrl)\">VIEW ON WEB</a></span></div><br/>"

        return finalHtml
    }
    
    class var webViewReadingCss : String{
        struct Static{
            static var onceToken : dispatch_once_t = 0
            static var instance : String? = nil
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            var file = NSBundle.mainBundle().pathForResource("MediaReadingCss", ofType: "css")
            var contents = NSString(contentsOfFile: file!, encoding: NSUTF8StringEncoding, error: nil)
            Static.instance = contents as? String
        })
        return Static.instance!
    }
}