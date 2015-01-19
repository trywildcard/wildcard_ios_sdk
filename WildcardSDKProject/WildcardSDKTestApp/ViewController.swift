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
        dummyCard = SummaryCard(url:google!, description: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.er the lazy dog.er the lazy dog.", title: "The Card Title -- Cards!.", imageUrl:NSURL(string: "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"))
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        if let newCardView = CardView.createCardView(dummyCard!, template:.SummaryCardNoImage){
            view.addSubview(newCardView)
            newCardView.horizontallyCenterToSuperView(0)
            newCardView.verticallyCenterToSuperView(-100)
            newCardView.constrainWidth(newCardView.frame.size.width,height:newCardView.frame.size.height)
            view.layoutIfNeeded()
        }
        
        SummaryCard.createFromUrl(NSURL(string: "http://www.cnn.com")!, completion: { (card:SummaryCard?, error:NSError?) -> Void in
            if(card != nil){
                self.presentCard(card!)
            }
        })
    }
    
    @IBAction func firstButtonTapped(sender: AnyObject) {
        presentCard(dummyCard!, template:WCTemplate.SummaryCard4x3FullImage)
    }
  
    @IBAction func presentCardButtonTapped(sender: AnyObject) {
        presentCard(dummyCard!, template:WCTemplate.SummaryCard4x3FloatRightImageTextWrap)
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        presentCard(dummyCard!, template:WCTemplate.SummaryCard4x3FloatRightImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

