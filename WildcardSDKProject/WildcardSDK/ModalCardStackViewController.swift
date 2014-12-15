//
//  ModalCardStackViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/12/14.
//
//

import UIKit

class ModalCardStackViewController: UIViewController, CardPhysicsDelegate {
    
    var presentingControllerBackgroundView:UIView?
    var blurredOverlayView:UIView?
    var cards:[Card] = []
    var backgroundTapRecognizer:UITapGestureRecognizer?
    
    var frontCard:Card?
    var backCard:Card?
    var frontCardView:CardView?
    var backCardView:CardView?
    var currentCardIndex:Int = 0
    
    var frontCardCenterX:NSLayoutConstraint?
    var frontCardCenterY:NSLayoutConstraint?
    var backCardCenterX:NSLayoutConstraint?
    var backCardCenterY:NSLayoutConstraint?
    
    // MARK: CardPhysicsDelegate
    func cardViewDropped(cardView: CardView, position: CGPoint) {
        
        // check if the card view has been dragged "out of bounds" in the view controller view(10% of edges)
        let viewBounds = view.bounds
        
        let horizontalThreshold = 0.10 * viewBounds.width
        let verticalThreshold = 0.10 * viewBounds.height
        
        // move left, right, up, or down
        if(position.x < horizontalThreshold){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.frontCardCenterX {
                    constraint.constant = constraint.constant - viewBounds.width
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }

        }else if(position.x > (view.bounds.width - horizontalThreshold)){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.frontCardCenterX {
                    constraint.constant = constraint.constant + viewBounds.width
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
            
        }else if(position.y < verticalThreshold){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.frontCardCenterY {
                    constraint.constant = constraint.constant - viewBounds.height
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
            
        }else if(position.y > (view.bounds.height - verticalThreshold)){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.frontCardCenterY {
                    constraint.constant = constraint.constant + viewBounds.height
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
        }else{
            cardView.physics?.panGestureReset()
        }
    }
    
    // MARK:Private
    func setupNextCard(){
        
        // back to front
        frontCard = backCard
        frontCardView = backCardView
        frontCardCenterX = backCardCenterX
        frontCardCenterY = backCardCenterY
        
        // up index
        currentCardIndex = nextIndex(currentCardIndex)
        
        // new back card
        let backCardIndex = nextIndex(currentCardIndex)
        let newBackCard = cards[backCardIndex]
        setupBackCard(newBackCard)
    }
    
    
    // MARK:UIViewController
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapped")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presentingControllerBackgroundView?.addGestureRecognizer(backgroundTapRecognizer!)
        
        // Initialize Front Card
        let frontCard = cards[0]
        frontCardView = CardView.createCardViewFromCard(frontCard)
        
        view.addSubview(frontCardView!)
        frontCardCenterX = frontCardView?.horizontallyConstrainToSuperView(0)
        frontCardCenterY = frontCardView?.verticallyConstrainToSuperView(0)
        
        frontCardView?.constrainWidth(cardSideLength(), andHeight: cardSideLength())
        frontCardView?.physics?.delegate = self
        frontCardView?.physics?.enableDragging = true
        
        setupBackCard(cards[1])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // blur background
        if(blurredOverlayView != nil){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.blurredOverlayView!.alpha = 0.95
            })
        }
    }
    
    // MARK: Private
    func backgroundTapped(){
        
        // unblur
        if(blurredOverlayView != nil){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.blurredOverlayView!.alpha = 0
                }, completion: {(bool:Bool) -> Void in
                    self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
            })
        }
    }
 
    func nextIndex(index:Int)->Int{
        return (index + 1) % cards.count
    }
    
    func cardSideLength()->CGFloat{
        return view.frame.size.width - (2 * CardContentView.DEFAULT_HORIZONTAL_PADDING)
    }
    
    func setupBackCard(card:Card){
        // set up the card in the back
        if(frontCardView != nil){
            backCard = card
            backCardView = CardView.createCardViewFromCard(card)
            backCardView?.physics?.delegate = self
            backCardView?.physics?.enableDragging = true
            
            view.insertSubview(backCardView!, belowSubview: frontCardView!)
            backCardCenterX = backCardView?.horizontallyConstrainToSuperView(0)
            backCardCenterY = backCardView?.verticallyConstrainToSuperView(0)
            backCardView?.constrainWidth(cardSideLength(), andHeight: cardSideLength())
        }
    }

}
