//
//  ViewController.swift
//  WildcardSDKTestApp
//
//  Created by David Xiang on 12/2/14.
//
//

import UIKit
import WildcardSDK

class ViewController: UIViewController, CardViewDelegate{
    
    var card:SummaryCard!
    var cardView:CardView!
    var newView:FullCardHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let media:NSMutableDictionary = NSMutableDictionary()
        media["imageUrl"] = "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"
        media["type"] = "image"
        
        
        let google = NSURL(string: "http://www.yahoo.com")
        card = SummaryCard(url:google!, description: "Yahoo is a veteran of the Internet. They recently spinned off a company called SpinCo to avoid paying billions of dollars in taxes for their stake in Alibaba.", title: "Yahoo Spinning Off SpinCo", media:media, data:nil)
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        if let cardView = CardView.createCardView(card, layout: WCCardLayout.SummaryCardNoImage){
            cardView.delegate = self
            view.addSubview(cardView)
            cardView.horizontallyCenterToSuperView(0)
            cardView.verticallyCenterToSuperView(0)
            self.cardView = cardView
            self.cardView.invalidateIntrinsicContentSize()
        }
    }
    
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        handleCardAction(cardView, action: action)
    }
    
    func cardViewLayoutSubviews(cardView: CardView) {
        println("CARD VIEW LAYOUT SUBVIEWS")
        
    }
    
    @IBAction func firstButtonTapped(sender: AnyObject) {
        presentCard(card!, layout: .SummaryCardTall, animated:true, completion:nil)
    }
  
    @IBAction func presentCardButtonTapped(sender: AnyObject) {
        presentCard(card!, layout: .SummaryCardImageOnly, animated:true, completion:nil)
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        presentCard(card!, layout:.SummaryCardShort, animated:true, completion:nil)
    }
    
    @IBAction func changeTitleButtonTapped(sender: AnyObject) {
        println("Change title tapped")
       // println(cardView.visualSource)
        if let header = cardView.visualSource.viewForCardHeader?() as? FullCardHeader{
            
            //println(header)
            //println(header.superview)
            //println(header.superview!.superview)
            //println(cardView)
            
            //header.title.font = UIFont(name:"HelveticaNeue-Medium", size: 36.0)!
            //header.contentEdgeInset = UIEdgeInsetsMake(20, 30, 20, 30)
           // println(header.intrinsicContentSize())
            //header.invalidateIntrinsicContentSize()
            //println(cardView.intrinsicContentSize())
            //view.layoutIfNeeded()
        }
        
        if let body = cardView.visualSource.viewForCardBody() as? ImageAndCaptionBody{
           // body.caption.font = UIFont(name:"HelveticaNeue-Medium", size: 24.0)!
            //body.contentEdgeInset = UIEdgeInsetsMake(10, 40, 20, 40)
           // body.imageViewSize = CGSizeMake(200, 200)
            //body.contentEdgeInset = UIEdgeInsetsMake(20, 30, 20, 30)
            body.imageAspectRatio = 0.5
            //body.captionSpacing = 30
            //body.imageAspectRatio = 0.5
 //           body.descriptionLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 36.0)!
        }
        
        /*
        if let footer = cardView.visualSource.viewForCardFooter?() as? ViewOnWebCardFooter{
            var buttonTitle = NSMutableAttributedString(string: "TESTT")
            buttonTitle.addAttribute(NSFontAttributeName, value:  UIFont(name:"HelveticaNeue-Medium", size: 36.0)!, range: NSMakeRange(0, countElements(buttonTitle.string)))
            footer.viewOnWebButton.setAttributedTitle(buttonTitle, forState: UIControlState.Normal)
        }
        */
        
        //if let body = cardView.visualSource.viewForCardBody() as? SingleParagraphCardBody{
        //    body.paragraphLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 24.0)!
        // }

        
            cardView.invalidateIntrinsicContentSize()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

