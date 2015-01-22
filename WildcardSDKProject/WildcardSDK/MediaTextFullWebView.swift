//
//  MediaTextFullWebView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/18/14.
//
//

import Foundation

class MediaTextFullWebView : CardViewElement, UIWebViewDelegate
{
    @IBOutlet weak var favicon: UIImageView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var webview: UIWebView!
    var downloadAppBarButton:UIBarButtonItem!
    var downloadAppIcon:UIImageView!
    
    // MARK: CardViewElement
    override func initializeElement() {
        favicon.layer.cornerRadius = 4.0
        favicon.layer.masksToBounds = true
        webview.delegate = self
        bottomToolbar.tintColor = UIColor.wildcardLightBlue()
        
        // initialize a download app button in case publisher has an app store link
        var downloadAppButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        downloadAppButton?.setTitle("DOWNLOAD APP", forState: UIControlState.Normal)
        downloadAppButton?.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 1, 0)
        downloadAppButton?.titleLabel!.font = WildcardSDK.cardActionButtonFont
        downloadAppButton?.setTitleColor(UIColor.wildcardLightBlue(), forState: UIControlState.Normal)
        downloadAppButton?.addTarget(self, action: "downloadAppButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        downloadAppButton?.sizeToFit()
        downloadAppBarButton = UIBarButtonItem(customView: downloadAppButton!)
        
        downloadAppIcon = UIImageView(frame: CGRectMake(0, 0, 25, 25))
        downloadAppIcon.layer.cornerRadius = 4.0
        downloadAppIcon.layer.masksToBounds = true
    }
    
    override func update() {
        if let articleCard = cardView.backingCard as? ArticleCard{
            // top right favicon
            if let url = articleCard.publisher.smallLogoUrl{
                favicon.downloadImageWithURL(url, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.favicon.image = image!
                        self.downloadAppIcon.image = image!
                    }
                })
            }
            webview?.loadHTMLString(constructFinalHtml(articleCard), baseURL: nil)
            updateToolbar()
        }
    }
    
    // MARK: Action
    func closeButtonTapped(sender: AnyObject) {
        cardView.delegate?.cardViewRequestedAction?(cardView, action: CardViewAction(type: .Collapse, parameters: nil))
    }
    
    func actionButtonTapped(sender:AnyObject){
        cardView.handleShare()
    }
    
    func downloadAppButtonTapped(sender:AnyObject){
        cardView.handleDownloadApp()
    }
    
    // MARK: Private
    func updateToolbar(){
        
        var barButtonItems:[AnyObject] = []
        var closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "closeButtonTapped:")
        barButtonItems.append(closeButton)
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barButtonItems.append(flexSpace)
        
        if let articleCard = cardView.backingCard as? ArticleCard{
            if let appStoreUrl = articleCard.publisher.appStoreUrl {
                
                // publisher logo
                var imageButton = UIBarButtonItem(customView: downloadAppIcon)
                imageButton.target = self
                imageButton.action = "downloadAppButtonTapped:"
                barButtonItems.append(imageButton)
                
                // download app button
                barButtonItems.append(downloadAppBarButton)
                
                // fixed spacing to left of action button
                var fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
                fixedSpace.width = 5
                barButtonItems.append(fixedSpace)
            }
        }
        
        var actionButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "actionButtonTapped:")
        barButtonItems.append(actionButton)
        
        bottomToolbar.setItems(barButtonItems, animated: false)
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
        
        finalHtml += "<div><center><span class=\"viewMore\"><a id=\"viewOnWeb\" href=\"\(articleCard.webUrl)\">VIEW ON WEB</a></span></div><br></br>"

        return finalHtml
    }
    
    class var webViewReadingCss : String{
        struct Static{
            static var onceToken : dispatch_once_t = 0
            static var instance : String? = nil
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            var file = NSBundle.wildcardSDKBundle().pathForResource("MediaReadingCss", ofType: "css")
            var contents = NSString(contentsOfFile: file!, encoding: NSUTF8StringEncoding, error: nil)
            Static.instance = contents as? String
        })
        return Static.instance!
    }
    
    // MARK: UIWebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(navigationType == .LinkClicked){
            cardView.handleViewOnWeb(request.URL)
            return false
        }else{
            return true
        }
    }
    
}