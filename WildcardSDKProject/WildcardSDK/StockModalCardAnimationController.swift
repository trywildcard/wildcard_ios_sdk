//
//  StockModalCardAnimationController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/19/14.
//
//

import UIKit

class StockModalCardAnimationController: NSObject,UIViewControllerAnimatedTransitioning {
    
    let isPresenting :Bool
    let duration :NSTimeInterval = 0.5
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
   
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)  {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        }else{
            animateDismissalWithTransitionContext(transitionContext)
        }
    }
    
    // MARK: Private
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView()
        
        containerView.addSubview(presentedControllerView)
        
        if let stockModalController = presentedController as? StockModalCardViewController{
            // pop up the card
            stockModalController.cardViewVerticalConstraint.constant = stockModalController.view.frame.size.height
            stockModalController.view.layoutIfNeeded()
            if(stockModalController.cardView != nil){
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    stockModalController.cardViewVerticalConstraint!.constant = 0
                    stockModalController.view.layoutIfNeeded()
                    }, completion: {(completed: Bool) -> Void in
                        transitionContext.completeTransition(completed)
                })
            }
        }
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()
        
        
        if let stockModalController = presentedController as? StockModalCardViewController{
            // move card up and out
            if(stockModalController.cardView != nil){
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    stockModalController.closeButton.alpha = 0
                    stockModalController.cardViewVerticalConstraint!.constant = -presentedControllerView.frame.size.height
                    stockModalController.view.layoutIfNeeded()
                    }, completion: {(completed: Bool) -> Void in
                        transitionContext.completeTransition(completed)
                })
            }
        }
     
    }
}
