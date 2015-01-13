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
    
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        if(action.type == .Maximize){
            maximizeArticleCard(cardView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.wildcardBackgroundGray()

        let articleUrl = NSURL(string: "http://www.freep.com/story/money/cars/detroit-auto-show/2015/01/12/2017-ford-shelby-gt-mustang-michigan-350r/21632001/")
        ArticleCard.createFromUrl(articleUrl!, completion: { (card:ArticleCard?, error:NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let articleCard = card {
                    if let newCardView = CardView.createCardView(articleCard){
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
