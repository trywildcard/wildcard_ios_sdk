//
//  CardPhysics.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import Foundation

public class CardPhysics : NSObject {
    
    var cardView:CardView
    var flipBoolean = false
    var cardSwipeGestureRecognizer: UISwipeGestureRecognizer?
    
    init(cardView:CardView){
        self.cardView = cardView
    }
    
    func cardSwiped(recognizer:UISwipeGestureRecognizer!){
        
        println("here")
    }
    
    
    func setup(){
        cardSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "cardSwiped:")
        self.cardView.addGestureRecognizer(cardSwipeGestureRecognizer!)
    }
    

    
    
}
