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
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        let media:NSMutableDictionary = NSMutableDictionary()
        let mediaDescription:NSMutableDictionary = NSMutableDictionary()
        mediaDescription["description"] = "Shar attack the quick brown fox jumped over he alzy dog. this is a test description. The quick brown fox jumped over the lazy dog. "
        media["imageUrl"] = "http://images.mid-day.com/2013/mar/shark-attack.jpg"
        media["type"] = "image"
        media["media"] = mediaDescription
        
        let google = NSURL(string: "http://www.yahoo.com")!
        card = SummaryCard(url:google, description: "Yahoo is a veteran of the Internet. They recently spinned off a company called SpinCo to avoid paying billions of dollars in taxes for their stake in Alibaba.", title: "Yahoo Spinning Off SpinCo", media:media, data:nil)
        
        let creator = Creator(name: "Youtube", url: google, favicon: nil, iosStore: nil, androidStore: nil)
        let vidCard = VideoCard(title: "Title of a video card. The quick bronw fox jumped over th elzzy dog. ", embedUrl: google, url: google, creator: creator, data: media)
        
        /*
        if let cardView = CardView.createCardView(vidCard, layout: WCCardLayout.VideoCardThumbnail){
            cardView.delegate = self
            view.addSubview(cardView)
            cardView.horizontallyCenterToSuperView(0)
            cardView.verticallyCenterToSuperView(0)
            self.cardView = cardView
        }
*/
        
        Card.getFromUrl(NSURL(string: "https://www.youtube.com/watch?v=r16ndBiHC-0")!, completion: { (card, error) -> Void in
            if let card = card  as? VideoCard{
                self.cardView = CardView.createCardView(card, layout: WCCardLayout.VideoCardThumbnail)
                self.cardView.delegate = self
                self.view.addSubview(self.cardView)
                self.cardView.horizontallyCenterToSuperView(0)
                self.cardView.verticallyCenterToSuperView(0)
            }
        })
    }
    
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        let cardAction = action
        switch(action.type){
        case .VideoDidStartPlaying:
            AppDelegate.sharedInstance().allowLandscape = true
        case .VideoWillEndPlaying:
            AppDelegate.sharedInstance().allowLandscape = false
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            break
        default:
            break
        }
        
        handleCardAction(cardView, action: action)
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    override func shouldAutorotate() -> Bool {
        return false
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
        println(cardView.frame)
       // println(cardView.visualSource)
        //cardView.preferredWidth = 200
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
        
        if let body = cardView.visualSource.viewForCardBody() as? VideoCardThumbnail {
            
            body.labelToVideoPadding = 50
            
           // body.imageViewSize = CGSizeMake(200, 200)
            //body.contentEdgeInset = UIEdgeInsetsMake(20, 30, 20, 30)
            //body.imageViewSize = CGSizeMake(40, 160)
            //body.imageAspectRatio = 0.5/
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

