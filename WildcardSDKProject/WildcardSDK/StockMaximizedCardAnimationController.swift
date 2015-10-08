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
    let duration :NSTimeInterval = 0.4
    
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
    
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let maximizedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as! StockMaximizedCardViewController
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView()
        
        let rectConvert = maximizedController.calculateMaximizedFrame()
    
        containerView!.addSubview(presentedControllerView)
  
        maximizedController.view.layoutIfNeeded()
        let originalShadowOpacity = maximizedController.maximizedCardView.layer.shadowOpacity
        maximizedController.maximizedCardView.layer.shadowOpacity = 0
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
    
            // move card to maximized constraints
            maximizedController.updateInternalCardConstraints(rectConvert)
            
            }, completion: {(completed: Bool) -> Void in
                maximizedController.maximizedCardView.layer.shadowOpacity = originalShadowOpacity
                transitionContext.completeTransition(completed)
        })
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let maximizedController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as! StockMaximizedCardViewController

        maximizedController.maximizedCardView?.fadeOut(duration/2, delay: 0, completion: nil)
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            // move card back to initial constraints
            maximizedController.updateInternalCardConstraints(maximizedController.initialCardFrame)
        
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
}
