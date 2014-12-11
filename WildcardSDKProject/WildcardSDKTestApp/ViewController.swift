//
//  ViewController.swift
//  WildcardSDKTestApp
//
//  Created by David Xiang on 12/2/14.
//
//

import UIKit
import WildcardSDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        let google = NSURL(string: "http://www.google.com")
        let dummyCard = WebLinkCard(url:google!, description: "Google is the best search engine in the world.", title: "Google", dictionary: nil)
        let layoutToRender:CardLayout = CardLayout.WebLinkCardPortraitDefault
        if let cardView = CardView.createCardViewFromCard(dummyCard, layout: layoutToRender){
            cardView.frame = CGRectOffset(cardView.frame, 15, 100)
            println(cardView)
            view.addSubview(cardView)
        }
        
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        let google = NSURL(string: "http://www.google.com")
        let dictionary:NSMutableDictionary = NSMutableDictionary()
        dictionary["primaryImageUrl"] = "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"
        let dummyCard = WebLinkCard(url:google!, description: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.", title: "This is an example of another card format", dictionary: dictionary )
        presentCard(dummyCard)
    }
    
    @IBAction func presentCardButtonTapped(sender: AnyObject) {
        let google = NSURL(string: "http://www.google.com")
        let dictionary:NSMutableDictionary = NSMutableDictionary()
        dictionary["primaryImageUrl"] = "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"
        let dummyCard = WebLinkCard(url:google!, description: "Yahoo is not quite as good as Google in Searching.", title: "Yahoo < Google", dictionary: dictionary )
        presentCard(dummyCard)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

