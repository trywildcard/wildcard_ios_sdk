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
    
    var dummyCard:WebLinkCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let google = NSURL(string: "http://www.google.com")
        let dictionary:NSMutableDictionary = NSMutableDictionary()
        dictionary["primaryImageUrl"] = "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"
        dummyCard = WebLinkCard(url:google!, description: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.", title: "The Card Title", dictionary: dictionary )
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        // render with stock data source
        let bareBones = BareBonesCardVisualSource(card:dummyCard!)
        let newCardView = CardView.createCardView(dummyCard!, visualSource: bareBones)
        
        view.addSubview(newCardView!)
        newCardView!.horizontallyCenterToSuperView(0)
        newCardView!.verticallyCenterToSuperView(-100)
        newCardView!.constrainWidth(bareBones.widthForCard(), height: newCardView!.frame.size.height)
        view.layoutIfNeeded()
        println(newCardView!.frame)
    }
    
    @IBAction func firstButtonTapped(sender: AnyObject) {
        let simple = SimpleDescriptionCardVisualSource(card:dummyCard!)
        presentCard(dummyCard!, customVisualSource: simple)
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        let thumbnailsource = ImageThumbnailFloatLeftVisualSource(card: dummyCard!)
        presentCard(dummyCard!, customVisualSource: thumbnailsource)
    }
    
    @IBAction func presentCardButtonTapped(sender: AnyObject) {
        let fullsource = ImageFullFloatBottomVisualSource(card: dummyCard!)
        presentCard(dummyCard!, customVisualSource: fullsource)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

