//
//  ViewController3.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/12/14.
//
//

import UIKit
import WildcardSDK

class ViewController3: UIViewController, CardViewDelegate {

    var articleCard:ArticleCard?
    
    @IBAction func present1ButtonTapped(sender: AnyObject) {
        presentCard(articleCard!, layout:.ArticleCardTall, animated:true, completion:nil)
    }
    @IBAction func present2ButtonTapped(sender: AnyObject) {
        presentCard(articleCard!, layout:.ArticleCardShort, animated:true, completion:nil)
    }
    
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        
        // any custom actions handling, analytics, etc.
        
        // Let Wildcard handle the Card Action
        handleCardAction(cardView, action: action)
    }
    @IBAction func present3ButtonTapped(sender: AnyObject) {
        presentCard(articleCard!, layout:.ArticleCardNoImage, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.wildcardBackgroundGray()

        let articleUrl = NSURL(string: "http://pitchfork.com/news/58110-aap-mob-founder-aap-yams-has-died/")
        Card.getFromUrl(articleUrl!, completion: { (card:Card?, error:NSError?) -> Void in
            if(card != nil){
                if let newCardView = CardView.createCardView(card!, layout: .ArticleCardNoImage){
                    newCardView.delegate = self
                    self.view.addSubview(newCardView)
                    newCardView.horizontallyCenterToSuperView(0)
                    newCardView.verticallyCenterToSuperView(0)
                    newCardView.constrainWidth(newCardView.frame.size.width, height: newCardView.frame.size.height)
                }
            }
        })
     
    }
}
