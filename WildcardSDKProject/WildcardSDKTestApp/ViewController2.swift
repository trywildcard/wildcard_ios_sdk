//
//  ViewController2.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import UIKit
import WildcardSDK

class ViewController2: UIViewController, CardViewDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var redditData:[NSDictionary] = []
    var counter = 0
    var mainCardView:CardView?
    @IBOutlet weak var reRenderButton: UIButton!
    var mainCardWidthConstraint:NSLayoutConstraint!
    var mainCardHeightConstraint:NSLayoutConstraint!
    
    func cardViewWillLayoutToNewSize(cardView:CardView, fromSize:CGSize, toSize:CGSize){
        mainCardWidthConstraint.constant = toSize.width
        mainCardHeightConstraint.constant = toSize.height
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        let google = NSURL(string: "http://www.google.com")
        let dummyCard = SummaryCard(url:google!, description: "Demonstrates re-rendering different cards in the same view", title: "One Card View, Multiple Cards", imageUrl:nil)
        let bareBones = SummaryCardNoImageVisualSource(card:dummyCard)
        if let cardView = CardView.createCardView(dummyCard, visualSource: bareBones){
            view.addSubview(cardView)
            cardView.horizontallyCenterToSuperView(0)
            cardView.verticallyCenterToSuperView(-50)
            mainCardWidthConstraint = cardView.constrainWidth(cardView.frame.size.width)
            mainCardHeightConstraint = cardView.constrainHeight(cardView.frame.size.height)
            cardView.delegate = self
            mainCardView = cardView
        }
        
        loadReddit()
    }
    
    func loadReddit(){
        
        let requestURL = NSURL(string:"https://www.reddit.com/new.json?limit=100")
        
        reRenderButton.enabled = false
        var session = NSURLSession.sharedSession()
        var task:NSURLSessionTask = session.dataTaskWithURL(requestURL!, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if(error != nil){
                // completion(nil, error)
            }else{
                var jsonError:NSError?
                var json:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
                if (jsonError != nil) {
                    println("JSON ERROR")
                }
                else {
                    if let data = json!["data"] as? NSDictionary{
                        if let children = data["children"] as? NSArray{
                            for child in children{
                                if let childData = child as? NSDictionary{
                                    if let data = childData["data"] as? NSDictionary{
                                        self.redditData.append(data)
                                    }
                                }
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.reRenderButton.enabled = true
                })
            }
        })
        task.resume()
    }
    
    
    @IBAction func reRenderTapped(sender: AnyObject) {
        // Attempt to create a web link card from this url to render it
        let index = counter++ % redditData.count
        let data = redditData[index]
        
        if let urlString = data["url"] as? String{
            if let title = data["title"] as? String{
                if let url = NSURL(string: urlString) {
                    // manually create a card if the url is just a jpg or png
                    if (urlString.rangeOfString("jpg") != nil || urlString.rangeOfString("png") != nil){
                        let params = NSMutableDictionary()
                        params["primaryImageUrl"] = urlString
                        let webLinkCard = SummaryCard(url: url, description: title, title: title, imageUrl:nil)
                        self.mainCardView!.reloadWithCard(webLinkCard)
                    }
                    else{
                        reRenderButton.enabled = false
                        spinner.startAnimating()
                        
                        SummaryCard.createFromUrl(url, completion: { (card:SummaryCard?, error:NSError?) -> Void in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.spinner.stopAnimating()
                                self.reRenderButton.enabled = true
                                if (error == nil && card != nil){
                                    self.mainCardView!.reloadWithCard(card!)
                                }
                            })
                        })
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
