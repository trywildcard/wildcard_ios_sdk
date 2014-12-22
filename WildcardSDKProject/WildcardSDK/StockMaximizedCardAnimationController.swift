//
//  StockMaximizedCardAnimationController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/19/14.
//
//

import Foundation
import UIKit

class StockMaximizedCardAnimationController: NSObject,UIViewControllerAnimatedTransitioning {
    
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
    
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let maximizedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as StockMaximizedCardViewController
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView()
        
        
        containerView.addSubview(presentedControllerView)
        
        if(maximizedController.cardView != nil){
            
            maximizedController.view.layoutIfNeeded()
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                maximizedController.cardViewLeftConstraint?.constant = 10
                maximizedController.cardViewTopConstraint?.constant = 25
                maximizedController.cardViewRightConstraint?.constant = 10
                maximizedController.cardViewBottomConstraint?.constant = 10
                maximizedController.view.layoutIfNeeded()
                
                
                }, completion: {(completed: Bool) -> Void in
                    transitionContext.completeTransition(completed)
            })
        }
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let maximizedController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as StockMaximizedCardViewController
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let containerView = transitionContext.containerView()
        
        // pop up the card
        if(maximizedController.cardView != nil){
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                maximizedController.cardView?.body?.alpha = 0
                maximizedController.cardView?.footer?.alpha = 0
                maximizedController.cardView?.header?.alpha = 0
                
                maximizedController.cardViewLeftConstraint?.constant = maximizedController.initialCardFrame.origin.x
                maximizedController.cardViewTopConstraint?.constant = maximizedController.initialCardFrame.origin.y
                maximizedController.cardViewRightConstraint?.constant = maximizedController.view.frame.size.width - maximizedController.initialCardFrame.origin.x - maximizedController.initialCardFrame.size.width
                maximizedController.cardViewBottomConstraint?.constant = maximizedController.view.frame.size.height - maximizedController.initialCardFrame.origin.y - maximizedController.initialCardFrame.size.height
                
                maximizedController.view.layoutIfNeeded()
                
                }, completion: {(completed: Bool) -> Void in
                    transitionContext.completeTransition(completed)
            })
        }
    }
}
