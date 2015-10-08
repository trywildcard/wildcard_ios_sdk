//
//  ModalCardPresentationController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/19/14.
//
//

import UIKit

/*
 * The only purpose of this presentation controller is to add a blur effect 
 * for the duration of the presentation
 *
 */
class StockModalCardPresentationController: UIPresentationController {
   
    lazy var blurView :UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor.clearColor()
        let blur = view.addBlurOverlay(UIBlurEffectStyle.Dark)
        blur.alpha = 0
        return blur
    }()
    
    override func presentationTransitionWillBegin() {
        self.blurView.frame = containerView!.bounds
        containerView!.addSubview(self.blurView)
        self.blurView.constrainToSuperViewEdges()
        
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.blurView.alpha = 1.0
                }, completion:nil)
        }
    }
    
    override func presentationTransitionDidEnd(completed: Bool)  {
        if !completed {
            blurView.removeFromSuperview()
        }
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
        }
    }
    
}
