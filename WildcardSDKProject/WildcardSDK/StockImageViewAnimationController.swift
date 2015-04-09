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
        let stockImageController = presentedController as! StockImageViewViewController
        
        // temp image framed at where the fromImageView is
        let tempImage = WCImageView(frame: containerView.convertRect(stockImageController.fromImageView.frame, fromView: stockImageController.fromImageView.superview))
        tempImage.backgroundColor = UIColor.clearColor()    
        tempImage.image = stockImageController.fromImageView.image
        tempImage.contentMode = stockImageController.fromImageView.contentMode
        containerView.addSubview(tempImage)
        
        // from image size
        let imageSize = stockImageController.fromImageView.image!.size
        
        // get destination dimensions
        let containerBounds = containerView.bounds
        var destinationHeight:CGFloat = 0
        var destinationWidth:CGFloat = 0
        if(containerBounds.width > containerBounds.height){
            // landscape
            destinationHeight = containerView.frame.size.height
            destinationWidth = destinationHeight * imageSize.width / imageSize.height
        }else{
            // portrait
            destinationWidth = containerView.frame.size.width;
            destinationHeight = destinationWidth * imageSize.height / imageSize.width
        }
        
        // grow temp image into the destination frame. designed to be identical to what the full screen looks like at default
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            tempImage.center = containerView.center
            tempImage.bounds = CGRectMake(0, 0,destinationWidth, destinationHeight)
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
        let stockImageController = presentedController as! StockImageViewViewController
        
        // from image size
        let imageSize = stockImageController.fromImageView.image!.size
        
        // get destination dimensions
        let containerBounds = containerView.bounds
        var destinationHeight:CGFloat = 0
        var destinationWidth:CGFloat = 0
        if(containerBounds.width > containerBounds.height){
            // landscape
            destinationHeight = containerView.frame.size.height
            destinationWidth = destinationHeight * imageSize.width / imageSize.height
        }else{
            // portrait
            destinationWidth = containerView.frame.size.width;
            destinationHeight = destinationWidth * imageSize.height / imageSize.width
        }
        
        // temp image framed w/ the full screen's image view
        let tempImage = WCImageView(frame: CGRectZero)
        tempImage.center = containerView.center
        tempImage.bounds = CGRectMake(0, 0, destinationWidth, destinationHeight)
        tempImage.backgroundColor = UIColor.clearColor()
        tempImage.image = stockImageController.fromImageView.image
        tempImage.contentMode = stockImageController.fromImageView.contentMode
        tempImage.clipsToBounds = true
        containerView.addSubview(tempImage)
        
        // temporary image is added, don't need the full screen view anymore
        presentedController.view.removeFromSuperview()
        
        // shrink temp image into the destination frame (what the user originally clicked)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            tempImage.frame = containerView.convertRect(stockImageController.fromImageView.frame, fromView: stockImageController.fromImageView.superview)
            }, completion: {(completed: Bool) -> Void in
                tempImage.removeFromSuperview()
                containerView.addSubview(presentedController.view)
                transitionContext.completeTransition(completed)
        })
        
        
    }
}