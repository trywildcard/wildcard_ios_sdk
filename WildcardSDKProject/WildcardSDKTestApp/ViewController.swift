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
        let bareBones = BareBonesCardDataSource(card:dummyCard!)
        let newCardView = CardView.createCardView(dummyCard!, datasource: bareBones)
        
        view.addSubview(newCardView!)
        newCardView!.horizontallyCenterToSuperView(0)
        newCardView!.verticallyCenterToSuperView(-100)
        newCardView!.constrainWidth(bareBones.widthForCard(), andHeight: newCardView!.frame.size.height)
    }
    @IBAction func firstButtonTapped(sender: AnyObject) {
        let simple = SimpleDescriptionCardDataSource(card:dummyCard!)
        presentCard(dummyCard!, customDatasource: simple)
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        let thumbnailsource = ImageThumbnailFloatLeftDataSource(card: dummyCard!)
        presentCard(dummyCard!, customDatasource: thumbnailsource)
    }
    
    @IBAction func presentCardButtonTapped(sender: AnyObject) {
        let fullsource = ImageFullFloatBottomDataSource(card: dummyCard!)
        presentCard(dummyCard!, customDatasource: fullsource)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

