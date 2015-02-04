//
//  ViewController.swift
//  WildcardSDKTestApp
//
//  Created by David Xiang on 12/2/14.
//
//

import UIKit
import WildcardSDK

class ViewController: UIViewController, CardViewDelegate, UITextViewDelegate {
    
    var dummyCard:SummaryCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let google = NSURL(string: "http://www.google.com")
        dummyCard = SummaryCard(url:google!, description: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.er the lazy dog.er the lazy dog.", title: "The Card Title -- Cards! Oh Yea!", imageUrl:NSURL(string: "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"))
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        if let newCardView = CardView.createCardView(dummyCard!, layout:.SummaryCardNoImage){
            newCardView.delegate = self
            view.addSubview(newCardView)
            newCardView.horizontallyCenterToSuperView(0)
            newCardView.verticallyCenterToSuperView(-50)
            newCardView.constrainWidth(newCardView.frame.size.width,height:newCardView.frame.size.height)
        }
    }
    
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        handleCardAction(cardView, action: action)
    }
    
    @IBAction func firstButtonTapped(sender: AnyObject) {
        presentCard(dummyCard!, layout:WCCardLayout.SummaryCard4x3FullImage, animated:true, completion:nil)
    }
  
    @IBAction func presentCardButtonTapped(sender: AnyObject) {
        let google = NSURL(string: "http://www.google.com")
        let noImage = SummaryCard(url:google!, description: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.er the lazy dog.er the lazy dog.", title: "The Card Title -- Cards! Oh Yea!", imageUrl:nil)
        presentCard(noImage, layout: .SummaryCardNoImage, animated:true, completion:nil)
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        presentCard(dummyCard!, layout:.SummaryCard4x3SmallImage, animated:true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        ArticleCard.createFromUrl(URL, completion: { (card:ArticleCard?, error:NSError?) -> Void in
            if let card = card {
                self.presentCard(card, animated: true, completion: nil)
            }else{
                UIApplication.sharedApplication().openURL(URL)
            }
        })
        return false
    }
}

