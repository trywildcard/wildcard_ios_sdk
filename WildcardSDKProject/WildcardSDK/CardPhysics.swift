//
//  CardPhysics.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import Foundation
import UIKit

public class CardPhysics : NSObject {
    
    var cardView:CardView
    var flipBoolean = false
    var cardSwipeRightGestureRecognizer: UISwipeGestureRecognizer?
    var cardSwipeLeftGestureRecognizer: UISwipeGestureRecognizer?
    var cardLongPressGestureRecognizer:UILongPressGestureRecognizer?
    
    init(cardView:CardView){
        self.cardView = cardView
    }
    
    // MARK: Gesture Handlers
    func cardSwipedRight(recognizer:UISwipeGestureRecognizer!){
        // these built in transitions automatically re assign super views, so gotta re constrain every time
        if(!flipBoolean){
            cardView.addSubview(cardView.backOfCard)
            cardView.backOfCard.constrainToSuperViewEdges()
            println(cardView.contentView?.subviews)
            println(cardView.contentView?.frame)
            UIView.transitionFromView(cardView.containerView, toView:cardView.backOfCard!, duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromLeft) { (bool:Bool) -> Void in
                self.flipBoolean = true
            }
        }else{
            cardView.addSubview(cardView.containerView)
            cardView.containerView.constrainToSuperViewEdges()
           // cardView.setNeedsLayout()
           // cardView.layoutIfNeeded()
           // cardView.layoutSubviews()
            //cardView.sizeToFit()
            println(cardView.contentView?.subviews)
            println(cardView.contentView?.frame)
            UIView.transitionFromView(cardView.backOfCard!, toView:cardView.containerView, duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromLeft) { (bool:Bool) -> Void in
                self.flipBoolean = false
            }
        }
    }
    
    func cardSwipedLeft(recognizer:UISwipeGestureRecognizer!){
        if(!flipBoolean){
            cardView.addSubview(cardView.backOfCard)
            cardView.backOfCard.constrainToSuperViewEdges()
            UIView.transitionFromView(cardView.containerView, toView:cardView.backOfCard!, duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromRight) { (bool:Bool) -> Void in
                self.flipBoolean = true
            }
        }else{
            cardView.addSubview(cardView.containerView)
            cardView.containerView.constrainToSuperViewEdges()
            UIView.transitionFromView(cardView.backOfCard!, toView:cardView.containerView, duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromRight) { (bool:Bool) -> Void in
                self.flipBoolean = false
            }
        }
    }
    
    func cardLongPress(recognizer:UILongPressGestureRecognizer!){
        if let parentVC = cardView.parentViewController(){
            parentVC.presentCard(cardView.backingCard)
        }
    }
    
    // MARK: Instance
    func setup(){
        cardSwipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "cardSwipedRight:")
        cardSwipeRightGestureRecognizer?.direction = UISwipeGestureRecognizerDirection.Right
        self.cardView.addGestureRecognizer(cardSwipeRightGestureRecognizer!)
        
        cardSwipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "cardSwipedLeft:")
        cardSwipeLeftGestureRecognizer?.direction = UISwipeGestureRecognizerDirection.Left
        self.cardView.addGestureRecognizer(cardSwipeLeftGestureRecognizer!)
        
        cardLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "cardLongPress:")
        self.cardView.addGestureRecognizer(cardLongPressGestureRecognizer!)
    }
    

    
    
}
