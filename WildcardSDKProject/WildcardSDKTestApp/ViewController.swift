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
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        // set up a dummy card
        let google = NSURL(string: "http://www.google.com")
        let dummyCard = WebLinkCard(url:google!, description: "Google is the best search engine in the world. It has crawled trillions of pages on the Internet. This is a Basic Card.", title: "Goliath", dictionary: nil)
        
        // render with stock data source
        let bareBones = SimpleDescriptionCardDataSource(card:dummyCard)
        let newCardView = CardView.createCardView(dummyCard, datasource: bareBones)
        
        view.addSubview(newCardView!)
        newCardView!.horizontallyCenterToSuperView(0)
        newCardView!.verticallyCenterToSuperView(-100)
        newCardView!.constrainWidth(bareBones.widthForCard(), andHeight: newCardView!.frame.size.height)
        
        
        for name in UIFont.familyNames()
        {
            if let nameString = name as? String{
                let names = UIFont.fontNamesForFamilyName(nameString)
                println(nameString)
                println(names)
            }
        }
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        let google = NSURL(string: "http://www.google.com")
        let dictionary:NSMutableDictionary = NSMutableDictionary()
        dictionary["primaryImageUrl"] = "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"
        let dummyCard = WebLinkCard(url:google!, description: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.", title: "This is an example of another card format", dictionary: dictionary )
        
        let thumbnailsource = ImageThumbnailFloatLeftDataSource(card: dummyCard)
        presentCard(dummyCard, customDatasource: thumbnailsource)
    }
    
    @IBAction func presentCardButtonTapped(sender: AnyObject) {
        let google = NSURL(string: "http://www.google.com")
        let dictionary:NSMutableDictionary = NSMutableDictionary()
        dictionary["primaryImageUrl"] = "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"
        let dummyCard = WebLinkCard(url:google!, description: "Yahoo is not quite as good as Google in Searching.", title: "Yahoo < Google", dictionary: dictionary )
        let fullsource = ImageFullFloatBottomDataSource(card: dummyCard)
        presentCard(dummyCard, customDatasource: fullsource)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

