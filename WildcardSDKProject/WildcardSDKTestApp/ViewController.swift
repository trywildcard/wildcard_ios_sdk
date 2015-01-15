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
    
    var dummyCard:SummaryCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let google = NSURL(string: "http://www.google.com")
        dummyCard = SummaryCard(url:google!, description: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.", title: "The Card Title -- Cards!", imageUrl:NSURL(string: "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"))
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        let simple = SimpleDescriptionCardVisualSource(card: dummyCard!)
        if let newCardView = CardView.createCardView(dummyCard!, visualSource: simple){
            view.addSubview(newCardView)
            newCardView.horizontallyCenterToSuperView(0)
            newCardView.verticallyCenterToSuperView(-100)
            newCardView.constrainWidth(newCardView.frame.size.width,height:newCardView.frame.size.height)
            view.layoutIfNeeded()
        }
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

