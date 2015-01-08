//
//  ViewController3.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/12/14.
//
//

import UIKit
import WildcardSDK

class ViewController4: UIViewController, CardViewDelegate {
    
    var dummyCardStack:[Card] = []
    @IBOutlet weak var presentButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.wildcardBackgroundGray()
        
        presentButton.enabled = false
        ArticleCard.search("isis", completion: { (cards:[ArticleCard]?, error:NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presentButton.enabled = true
                if(cards != nil){
                    self.dummyCardStack = cards!
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
