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
        
        println(WildcardSDKVersionNumber)
        view.backgroundColor = UIColor(red: 213/255, green: 219/255, blue: 229/255, alpha: 1.0)
        
        let google = NSURL(string: "http://www.google.com")
        let dummyCard = WebLinkCard(url:google!, description: "Google is the best search engine in the world.", title: "Google", dictionary: nil)
        let cardView = CardViewRenderer.renderViewFromCard(dummyCard, layout: CardLayout.BareCard)
        
        cardView?.frame = CGRectMake(40, 100, 200,200)
       // cardView?.layoutIfNeeded()
        
        println(cardView)
        view.addSubview(cardView!)
        
        /*
        let label = UILabel(frame: CGRectZero)
        label.font = UIFont(name: "Polaris-Bold", size: 14.0)
        println(label.font)
        label.text = "TEST"
        label.sizeToFit()
        view.addSubview(label)
*/
        
        
        println("FONTS")
       // Utilities.printFontFamilies()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

