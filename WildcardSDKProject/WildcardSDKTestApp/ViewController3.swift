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
        presentCard(articleCard!, layout:.ArticleCard4x3FullImage)
    }
    @IBAction func present2ButtonTapped(sender: AnyObject) {
        presentCard(articleCard!, layout:.ArticleCard4x3FloatRightImageTextWrap)
    }
    
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        if(action.type == .Maximize){
            maximizeArticleCard(cardView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.wildcardBackgroundGray()

        let articleUrl = NSURL(string: "http://pitchfork.com/news/58110-aap-mob-founder-aap-yams-has-died/")
        ArticleCard.createFromUrl(articleUrl!, completion: { (card:ArticleCard?, error:NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let articleCard = card {
                    self.articleCard = articleCard
                    if let newCardView = CardView.createCardView(articleCard, layout: .ArticleCardNoImage){
                        newCardView.delegate = self
                        self.view.addSubview(newCardView)
                        newCardView.horizontallyCenterToSuperView(0)
                        newCardView.verticallyCenterToSuperView(0)
                        newCardView.constrainWidth(newCardView.frame.size.width, height: newCardView.frame.size.height)
                    }
                }
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
