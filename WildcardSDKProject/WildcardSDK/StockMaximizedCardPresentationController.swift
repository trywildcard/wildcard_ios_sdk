//
//  StockMaximizedCardPresentationController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/21/14.
//
//

import Foundation

class StockMaximizedCardPresentationController :UIPresentationController
{
    var presentingCardView:CardView!
    
    lazy var blurView :UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor.clearColor()
        let blur = view.addBlurOverlay(UIBlurEffectStyle.Dark)
        blur.alpha = 0
        return blur
        }()
    
    override func presentationTransitionWillBegin() {
        self.blurView.frame = self.containerView.bounds
        self.containerView.addSubview(self.blurView)
        self.blurView.constrainToSuperViewEdges()
        
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.blurView.alpha = 0.75
                }, completion:nil)
        }
    }
    
    override func presentationTransitionDidEnd(completed: Bool)  {
        if !completed {
            blurView.removeFromSuperview()
        }
        presentingCardView.fadeOut(0, delay: 0, completion: nil)
    }
    
    override func dismissalTransitionWillBegin()  {
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.blurView.alpha  = 0.0
                }, completion:nil)
        }
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            blurView.removeFromSuperview()
            presentingCardView.fadeIn(0.3, delay: 0, completion: nil)
        }
    }
}