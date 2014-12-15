//
//  ViewController3.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/12/14.
//
//

import UIKit
import WildcardSDK

class ViewController3: UIViewController {

    var dummyCardStack:[Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.wildcardBackgroundGray()
        let url = NSURL(string:"http://www.google.com")!
        let dictionary:NSMutableDictionary = NSMutableDictionary()
        dictionary["primaryImageUrl"] = "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"
        
        for index in 1...3 {
            let dummyCard = WebLinkCard(url: url, description: "The quick brown fox jumped over the lazy dog", title: "Mock Card", dictionary: dictionary)
            dummyCardStack.append(dummyCard)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func presentButtonTapped(sender: AnyObject) {
        presentCardsAsStack(dummyCardStack)
    }

}
