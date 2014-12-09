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
        if let cardView = CardViewRenderer.renderViewFromCard(dummyCard, layout: CardLayout.BareCard){
            cardView.frame = CGRectOffset(cardView.frame, 15, 100)
            println(cardView)
            view.addSubview(cardView)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

