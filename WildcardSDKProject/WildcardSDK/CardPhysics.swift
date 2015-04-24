//
//  CardPhysics.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import UIKit

@objc
public protocol CardPhysicsDelegate{
    optional func cardViewDragged(cardView:CardView, position:CGPoint)
    optional func cardViewDropped(cardView:CardView, position:CGPoint)
    optional func cardViewTapped(cardView:CardView)
    optional func cardViewDoubleTapped(cardView:CardView)
}

@objc
public class CardPhysics : NSObject {
    
    // MARK: Public properties
    public var cardView:CardView
    public var delegate:CardPhysicsDelegate?

    /// Adds a pan gesture onto the card view which enables it to be dragged around the screen
    public var enableDragging: Bool {
        get {
            return cardPanGestureRecognizer != nil
        }
        set(bool) {
            if(bool){
                cardPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "cardPanned:")
                cardView.addGestureRecognizer(cardPanGestureRecognizer!)
                originalPosition = cardView.center
            }else{
                if let gesture = cardPanGestureRecognizer{
                    cardView.removeGestureRecognizer(gesture)
                    cardPanGestureRecognizer = nil
                }
            }
        }
    }
    
    // MARK: Private properties
    var flipBoolean = false
    var cardPanGestureRecognizer:UIPanGestureRecognizer?
    var cardDoubleTapGestureRecognizer:UITapGestureRecognizer?
    var cardTapGestureRecognizer:UITapGestureRecognizer?
    var touchPosition:CGPoint = CGPointZero
    var originalPosition:CGPoint = CGPointZero
    
    // MARK: Initializers
    init(cardView:CardView){
        self.cardView = cardView
    }
    
    // MARK: Gesture Handlers
    func cardPanned(recognizer:UIPanGestureRecognizer!){
        if recognizer.state == UIGestureRecognizerState.Began{
            self.cardView.layer.removeAllAnimations()
            touchPosition = recognizer.translationInView(cardView.superview!)
        }else if(recognizer.state == UIGestureRecognizerState.Changed){
            let currentLocation = recognizer.translationInView(cardView.superview!)
            let dx = currentLocation.x - touchPosition.x
            let dy = currentLocation.y - touchPosition.y
            
            moveByAmount(CGPointMake(dx, dy))
            
            let finalX = dx + originalPosition.x
            let finalY = dy + originalPosition.y
            delegate?.cardViewDragged?(cardView, position: CGPointMake(finalX, finalY))
            
        }else if(recognizer.state == UIGestureRecognizerState.Ended){
            let currentLocation = recognizer.translationInView(cardView.superview!)
            let velocity = recognizer.velocityInView(cardView.superview)
            
            // approximate final position
            let deccelerationRate:CGFloat = 10.0
            let dx:CGFloat = (currentLocation.x - touchPosition.x) + velocity.x / deccelerationRate
            let dy:CGFloat = (currentLocation.y - touchPosition.y) + velocity.y / deccelerationRate
            
            moveByAmount(CGPointMake(dx,dy))
            
            let finalX = dx + originalPosition.x;
            let finalY = dy + originalPosition.y;
            delegate?.cardViewDropped?(cardView, position: CGPointMake(finalX,finalY))
            
        }else if(recognizer.state == UIGestureRecognizerState.Cancelled) {
            panGestureReset()
        }
    }
    
    func moveByAmount(delta:CGPoint){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth:CGFloat = screenRect.size.width
        let screenHeight:CGFloat = screenRect.size.height
        let deltaX:CGFloat = min(max(delta.x, -screenWidth), screenWidth);
        let deltaY:CGFloat = min(max(delta.y, -screenHeight), screenHeight);
        let translation:CGAffineTransform = CGAffineTransformMakeTranslation(deltaX, deltaY)
        let MAX_ANGLE:CGFloat = 45;
        let squaredSum:CGFloat = (deltaX * deltaX + deltaY * deltaY)
        let degrees:CGFloat = MAX_ANGLE * ((deltaX * deltaY) * 2 / squaredSum) * (sqrt(squaredSum) / sqrt(screenWidth * screenWidth + screenHeight * screenHeight))
        let M_PI_CGFLOAT:CGFloat = CGFloat(M_PI)
        let rotation:CGAffineTransform = CGAffineTransformMakeRotation(M_PI_CGFLOAT * (-degrees/180.0))
        cardView.transform = CGAffineTransformConcat(rotation,translation)
    }
   
    func panGestureReset()
    {
        cardPanGestureRecognizer?.enabled = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.cardView.transform = CGAffineTransformIdentity
            }){ (bool:Bool) -> Void in
                self.cardPanGestureRecognizer?.enabled = true
                return
        }
    }
    
    func cardDoubleTapped(recognizer:UITapGestureRecognizer!){
        WildcardSDK.analytics?.trackEvent("CardEngaged", withProperties: ["cta":"cardDoubleTapped"], withCard: cardView.backingCard)
        delegate?.cardViewDoubleTapped?(cardView)
        
        if(cardView.back != nil){
            // these built in transitions automatically re assign super views, so gotta re constrain every time
            if(!flipBoolean){
                cardView.addSubview(cardView.back!)
                cardView.back!.constrainToSuperViewEdges()
                UIView.transitionFromView(cardView.containerView, toView:cardView.back!, duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromLeft) { (bool:Bool) -> Void in
                    self.flipBoolean = true
                }
            }else{
                cardView.addSubview(cardView.containerView)
                cardView.containerView.constrainToSuperViewEdges()
                UIView.transitionFromView(cardView.back!, toView:cardView.containerView, duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromRight) { (bool:Bool) -> Void in
                    self.flipBoolean = false
                }
            }
        }
    }
    
    func cardTapped(recognizer:UITapGestureRecognizer!){
        WildcardSDK.analytics?.trackEvent("CardEngaged", withProperties: ["cta":"cardTapped"], withCard: cardView.backingCard)
        delegate?.cardViewTapped?(cardView)
        
        // full card is tapped, depending on the layout we can do different things
        if cardView.visualSource is SummaryCardTwitterTweetVisualSource{
            cardView.handleViewOnWeb(cardView.backingCard.webUrl)
        }else if cardView.visualSource is SummaryCardTwitterProfileVisualSource{
            cardView.handleViewOnWeb(cardView.backingCard.webUrl)
        }
       
    }
    
    // MARK: Instance
    func setup(){
        cardDoubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "cardDoubleTapped:")
        cardDoubleTapGestureRecognizer?.numberOfTapsRequired = 2
        cardView.addGestureRecognizer(cardDoubleTapGestureRecognizer!)
        
        cardTapGestureRecognizer = UITapGestureRecognizer(target:self, action: "cardTapped:")
        cardTapGestureRecognizer?.numberOfTapsRequired = 1
        cardView.addGestureRecognizer(cardTapGestureRecognizer!)
    }
    
}
