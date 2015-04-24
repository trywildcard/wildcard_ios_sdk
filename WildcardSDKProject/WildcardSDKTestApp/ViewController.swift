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
    var imageCard:ImageCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        title = "Test Bench"
 
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Card.getFromUrl(NSURL(string: "https://www.flickr.com/photos/christophebrutel/17242890442/in/explore-2015-04-23")!, completion: { (card, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let card = card{
                self.cardView = CardView.createCardView(card)
                self.cardView.delegate = self
                self.view.addSubview(self.cardView)
                self.cardView.horizontallyCenterToSuperView(0)
                self.cardView.verticallyCenterToSuperView(0)
            }
        })
    }
    
    @IBAction func testButtonTapped(sender: AnyObject) {
        println("tapped test button")
        
        self.cardView.preferredWidth = 100
        
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
        case .ImageDidEnterFullScreen:
            AppDelegate.sharedInstance().allowLandscape = true
        case .ImageWillExitFullScreen:
            AppDelegate.sharedInstance().allowLandscape = false
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            break
        default:
            break
        }
        
        handleCardAction(cardView, action: action)
    }
    
}

