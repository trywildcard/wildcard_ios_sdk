//
//  MediaTextFullWebView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/18/14.
//
//

import Foundation

@objc
public class MediaTextFullWebView : CardViewElement, UIWebViewDelegate
{
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var webview: UIWebView!
    
    // MARK: CardViewElement
    override public func initialize() {
        webview.delegate = self
        bottomToolbar.tintColor = UIColor.wildcardLightBlue()
    }
    
    override public func update(card:Card) {
        if let articleCard = card as? ArticleCard{
            webview?.loadHTMLString(constructFinalHtml(articleCard), baseURL: card.webUrl)
            updateToolbar(articleCard)
        }
    }
    
    // MARK: Action
    func closeButtonTapped(sender: AnyObject) {
        if(cardView != nil){
            cardView!.delegate?.cardViewRequestedAction?(cardView!, action: CardViewAction(type: .Collapse, parameters: nil))
        }
    }
    
    func actionButtonTapped(sender:AnyObject){
        if(cardView != nil){
            WildcardSDK.analytics?.trackEvent("CardEngaged", withProperties: ["cta":"shareAction"], withCard: cardView!.backingCard)
            cardView!.handleShare()
        }
    }
    
    // MARK: Private
    func updateToolbar(card:Card){
        
        var barButtonItems:[UIBarButtonItem] = []
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "closeButtonTapped:")
        barButtonItems.append(closeButton)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barButtonItems.append(flexSpace)
        
        let actionButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "actionButtonTapped:")
        barButtonItems.append(actionButton)
        
        bottomToolbar.setItems(barButtonItems, animated: false)
    }
    
    func constructFinalHtml(articleCard:ArticleCard)->String{
        var finalHtml:String = ""
        finalHtml += "<html>"
        finalHtml += "<head>"
        finalHtml += MediaTextFullWebView.webViewReadingCss
        finalHtml += "</head>"
        
        finalHtml += "<body>"
        
        finalHtml +=  "<div id=\"customWildcardKicker\">\(articleCard.creator.name.uppercaseString)</div>"
        finalHtml +=  "<div id=\"customHairline\"></div>"
        finalHtml +=  "<div id=\"customWildcardHeader\">\(articleCard.title)</div>"
        
        let publishedDateFormatter = NSDateFormatter()
        publishedDateFormatter.dateFormat = "MMM dd, YYYY"
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
        
        finalHtml +=  "<div id=\"customHairline\"></div>"
        
        finalHtml += articleCard.html!
        
        finalHtml += "<div><center><span class=\"viewMore\"><a id=\"viewOnWeb\" href=\"\(articleCard.webUrl)\">VIEW ON WEB</a></span></div><br></br>"
        
        finalHtml += "</body>"
        finalHtml += "</html>"

        return finalHtml
    }
    
    private class var webViewReadingCss : String{
        struct Static{
            static var onceToken : dispatch_once_t = 0
            static var instance : String? = nil
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            let file = NSBundle.wildcardSDKBundle().pathForResource("MediaReadingCss", ofType: "css")
            let contents = try? NSString(contentsOfFile: file!, encoding: NSUTF8StringEncoding)
            Static.instance = contents as? String
        })
        return Static.instance!
    }
    
    // MARK: UIWebViewDelegate
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(navigationType == .LinkClicked){
            if(cardView != nil){
                WildcardSDK.analytics?.trackEvent("CardEngaged", withProperties: ["cta":"linkClicked"], withCard: cardView!.backingCard)
                cardView!.handleViewOnWeb(request.URL!)
            }
            return false
        }else{
            return true
        }
    }
    
}