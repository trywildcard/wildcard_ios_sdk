//
//  StockImageViewPresentationController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/1/15.
//
//

import Foundation

class StockImageViewPresentationController: UIPresentationController {
    
    lazy var backgroundView :UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.0
        return view
        }()
    
    override func presentationTransitionWillBegin() {
        containerView!.addSubview(self.backgroundView)
        backgroundView.constrainToSuperViewEdges()
        
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.backgroundView.alpha = 1.0
                }, completion:nil)
        }
    }
    
    override func presentationTransitionDidEnd(completed: Bool)  {
        if !completed {
            backgroundView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin()  {
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.backgroundView.alpha  = 0.0
                }, completion:nil)
        }
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            backgroundView.removeFromSuperview()
        }
    }
    
}