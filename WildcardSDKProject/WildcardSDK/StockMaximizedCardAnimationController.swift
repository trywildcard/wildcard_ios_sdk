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
        
        // insets relative to the application frame
        let applicationInsets = maximizedController.maximizedCardVisualSource.applicationFrameEdgeInsets()
        let applicationFrame = UIScreen.mainScreen().applicationFrame
        
        // this is the card frame in the coordinate space of the application frame / main screen
        let cardFrame = CGRectMake(applicationFrame.origin.x + applicationInsets.left, applicationFrame.origin.y + applicationInsets.top, applicationFrame.width - applicationInsets.left - applicationInsets.right, applicationFrame.height - applicationInsets.top - applicationInsets.bottom)
        
        // convert to a rectangle in view controller space
        let rectConvert = maximizedController.view.convertRect(cardFrame, fromCoordinateSpace: UIScreen.mainScreen().coordinateSpace)
        
        containerView.addSubview(presentedControllerView)
        
        maximizedController.view.layoutIfNeeded()
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            maximizedController.cardViewLeftConstraint?.constant = rectConvert.origin.x
            maximizedController.cardViewTopConstraint?.constant = rectConvert.origin.y
            maximizedController.cardViewRightConstraint?.constant = maximizedController.view.frame.size.width - rectConvert.origin.x - rectConvert.width
            maximizedController.cardViewBottomConstraint?.constant = maximizedController.view.frame.size.height - rectConvert.origin.y - rectConvert.height
            maximizedController.view.layoutIfNeeded()
            
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let maximizedController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as StockMaximizedCardViewController
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let containerView = transitionContext.containerView()
        
        // pop up the card
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            //maximizedController.maximizedCardView?.body?.alpha = 0
           // maximizedController.maximizedCardView?.footer?.alpha = 0
          //  maximizedController.maximizedCardView?.header?.alpha = 0
            
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
