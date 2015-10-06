//
//  StockModalCardAnimationController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/19/14.
//
//

import UIKit

class StockModalCardAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting :Bool
    let duration :NSTimeInterval = 0.5
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
   
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
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
        if let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey) {
            let center = presentedView.center
            presentedView.center = CGPointMake(center.x, -presentedView.bounds.size.height)
            transitionContext.containerView()!.addSubview(presentedView)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext),
                delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut,
                animations: {
                    presentedView.center = center
                }, completion: {
                    (completed: Bool) -> Void in
                    transitionContext.completeTransition(completed)
            })
        }
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
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
