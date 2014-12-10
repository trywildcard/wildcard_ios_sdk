//
//  ViewController2.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import UIKit
import WildcardSDK

class ViewController2: UIViewController {
    
    var links:[NSURL] = []
    var counter = 0
    var mainCardView:CardView?
    @IBOutlet weak var reRenderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        let google = NSURL(string: "http://www.google.com")
        let dummyCard = WebLinkCard(url:google!, description: "Bare Bones Card", title: "Bare Bones Card", dictionary: nil)
        if let cardView = CardViewRenderer.renderViewFromCard(dummyCard, layout: CardLayout.BareCard){
            cardView.frame = CGRectOffset(cardView.frame, 15, 100)
            println(cardView)
            view.addSubview(cardView)
            mainCardView = cardView
        }
        
        let requestURL = NSURL(string:"https://www.reddit.com/new.json")
        
        reRenderButton.enabled = false
        var session = NSURLSession.sharedSession()
        var task:NSURLSessionTask = session.dataTaskWithURL(requestURL!, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if(error != nil){
               // completion(nil, error)
            }else{
                var jsonError:NSError?
                var json:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
                if (jsonError != nil) {
                    //completion(nil, jsonError)
                    println("JSON ERROR")
                }
                else {
                    if let data = json!["data"] as? NSDictionary{
                        if let children = data["children"] as? NSArray{
                            for child in children{
                                if let childData = child as? NSDictionary{
                                    if let data = childData["data"] as? NSDictionary{
                                        if let url = data["url"] as? String{
                                            if let redditUrl = NSURL(string: url){
                                                self.links.append(redditUrl)
                                            }
                                        }
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
        println("Rerender tapped")
        
        // Attempt to create a web link card from this url to render it
        let index = counter++ % links.count
        let url = links[index]
        reRenderButton.enabled = false
        WebLinkCard.createFromWebUrl(url, completion: { (card:WebLinkCard?, error:NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.reRenderButton.enabled = true
                if (error == nil && card != nil){
                    self.mainCardView!.renderCard(card!)
                }
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}