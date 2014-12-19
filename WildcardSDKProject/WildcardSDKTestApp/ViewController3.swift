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

    var dummyCardStack:[Card] = []
    @IBOutlet weak var presentButton: UIButton!
    
    func cardViewRequestedMaximize(cardView: CardView) {
        // use wildcard's stock maximize presentation
        maximizeCardView(cardView)
        // or do something else
        // ...
    }
    
    func cardViewRequestedCollapse(cardView: CardView) {
        println("requested collapse")
        
    }
    
   // func cardViewRequestedCollapse(cardView: CardView) {
    //    <#code#>
   // }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.wildcardBackgroundGray()

        presentButton.enabled = false
        ArticleCard.searchArticleCards("isis", completion: { (cards:[ArticleCard]?, error:NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presentButton.enabled = true
                if(cards != nil){
                    self.dummyCardStack = cards!
                }
            })
        })
        
        
        let articleUrl = NSURL(string: "http://www.cnn.com/2014/12/03/justice/new-york-grand-jury-chokehold/index.html?hpt=ju_c2")
        ArticleCard.createFromWebUrl(articleUrl!, completion: { (card:ArticleCard?, error:NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let articleCard = card {
                    if let newCardView = CardView.createCardView(articleCard){
                        newCardView.delegate = self
                        self.view.addSubview(newCardView)
                        newCardView.horizontallyCenterToSuperView(0)
                        newCardView.verticallyCenterToSuperView(0)
                        newCardView.constrainWidth(newCardView.frame.size.width, andHeight: newCardView.frame.size.height)
                    }
                }
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func presentButtonTapped(sender: AnyObject) {
        presentCardsAsStack(dummyCardStack)
    }

}
