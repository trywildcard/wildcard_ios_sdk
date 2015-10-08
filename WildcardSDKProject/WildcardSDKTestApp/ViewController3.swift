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
    var cardView:CardView!
    
    @IBAction func present1ButtonTapped(sender: AnyObject) {
        presentCard(articleCard!, layout:.ArticleCardTall, animated:true, completion:nil)
    }
    @IBAction func present2ButtonTapped(sender: AnyObject) {
        presentCard(articleCard!, layout:.ArticleCardShort, animated:true, completion:nil)
    }
    
    @IBAction func testButtonTapped(sender: AnyObject) {
        
        if let _ = cardView.visualSource.viewForCardHeader?() as? FullCardHeader{
           
          //  header.title.font = UIFont(name:"HelveticaNeue-Medium", size: 36.0)!
          
        }
        
        if let _ = cardView.visualSource.viewForCardBody() as? ImageFloatRightBody{
            // body.caption.font = UIFont(name:"HelveticaNeue-Medium", size: 24.0)!
            //body.contentEdgeInset = UIEdgeInsetsMake(10, 40, 20, 40)
            // body.imageViewSize = CGSizeMake(200, 200)
            //body.contentEdgeInset = UIEdgeInsetsMake(20, 30, 20, 30)
            
            //body.imageViewSize = CGSizeMake(100, 200)
            //body.captionSpacing = 30
            //body.imageAspectRatio = 0.5
            //           body.descriptionLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 36.0)!
        }
        
        cardView.invalidateIntrinsicContentSize()
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
        
        //let articleUrl = NSURL(string: "http://www.engadget.com/2015/02/05/one-dollar-lightning-cable/")
        
        let articleUrl = NSURL(string: "http://pitchfork.com/news/58110-aap-mob-founder-aap-yams-has-died/")
        //let articleUrl = NSURL(string: "http://theatlantic.com")
        Card.getFromUrl(articleUrl!, completion: { (card:Card?, error:NSError?) -> Void in
            if(card != nil){
                self.articleCard = card as? ArticleCard
                if let newCardView = CardView.createCardView(card!, layout: .ArticleCardShort){
                    newCardView.delegate = self
                    self.view.addSubview(newCardView)
                    newCardView.horizontallyCenterToSuperView(0)
                    newCardView.verticallyCenterToSuperView(0)
                    self.cardView = newCardView
                }
            }
        })
    }
}
