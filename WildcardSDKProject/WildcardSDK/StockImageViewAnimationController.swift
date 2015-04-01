//
//  StockImageViewAnimationController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/1/15.
//
//

import Foundation

class StockImageViewAnimationController: NSObject,UIViewControllerAnimatedTransitioning {
    
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
        let stockImageController = presentedController as StockImageViewViewController
        stockImageController.view.layoutIfNeeded()
        
        // temp image framed at where the fromImageView is
        let tempImageFrame = containerView.convertRect(stockImageController.fromImageView.frame, fromView: stockImageController.fromImageView.superview)
        let tempImage = WCImageView(frame: tempImageFrame)
        tempImage.backgroundColor = UIColor.clearColor()    
        tempImage.image = stockImageController.fromImageView.image
        tempImage.contentMode = stockImageController.imageView.contentMode
        containerView.addSubview(tempImage)
        
        // grow temp image into the destination frame
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            tempImage.frame = containerView.frame
            }, completion: {(completed: Bool) -> Void in
                tempImage.removeFromSuperview()
                containerView.addSubview(presentedController.view)
                transitionContext.completeTransition(completed)
        })
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()
        
        let stockImageController = presentedController as StockImageViewViewController
        
        let destinationFrame = containerView.convertRect(stockImageController.fromImageView.frame, fromView: stockImageController.fromImageView.superview)
        let presentedImageView = containerView.convertRect(stockImageController.imageView.frame, fromView: stockImageController.imageView.superview)
        let tempImage = WCImageView(frame: presentedImageView)
        tempImage.backgroundColor = UIColor.clearColor()
        tempImage.image = stockImageController.imageView.image
        tempImage.contentMode = .ScaleAspectFit
        tempImage.clipsToBounds = true
        containerView.addSubview(tempImage)
        presentedController.view.removeFromSuperview()
        
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            tempImage.frame = destinationFrame
            }, completion: {(completed: Bool) -> Void in
                tempImage.removeFromSuperview()
                containerView.addSubview(presentedController.view)
                transitionContext.completeTransition(completed)
        })
        
        
    }
}