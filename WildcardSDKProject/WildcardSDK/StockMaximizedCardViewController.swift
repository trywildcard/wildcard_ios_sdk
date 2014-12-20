//
//  ModalMaximizedCardViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/18/14.
//
//

import UIKit

class StockMaximizedCardViewController: UIViewController, CardPhysicsDelegate, CardViewDelegate,UIViewControllerTransitioningDelegate {
    
    var presentingControllerBackgroundView:UIView?
    var blurredOverlayView:UIView?
    var cardView:CardView?
    var maximizedCard:Card!
    var maximizedCardDataSource:CardViewDataSource!
    
    var cardDataSource:CardViewDataSource!
    var cardViewTopConstraint:NSLayoutConstraint?
    var cardViewBottomConstraint:NSLayoutConstraint?
    var cardViewLeftConstraint:NSLayoutConstraint?
    var cardViewRightConstraint:NSLayoutConstraint?
    
    var initialCardFrame:CGRect!
    var initialCardDataSource:CardViewDataSource!
    
    var destinationCardFrame:CGRect!
    
    var loaded:Bool = false
    
    func cardViewRequestedCollapse(cardView: CardView) {
       // cardView.reloadWithCard(maximizedCard, datasource: initialCardDataSource)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: CardPhysicsDelegate
    func cardViewDropped(cardView: CardView, position: CGPoint) {
        cardView.physics?.panGestureReset()
    }
    
    // MARK:UIViewController
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView = CardView.createCardView(maximizedCard, datasource: initialCardDataSource)
        cardView?.delegate = self
        cardView!.frame = initialCardFrame
        
        view.addSubview(cardView!)
        
        //initiailize constraints
        cardViewLeftConstraint = cardView?.constrainLeftToSuperView(initialCardFrame.origin.x)
        cardViewTopConstraint = cardView?.constrainTopToSuperView(initialCardFrame.origin.y)
        cardViewRightConstraint = cardView?.constrainRightToSuperView(view.frame.size.width - initialCardFrame.origin.x - initialCardFrame.size.width)
        cardViewBottomConstraint = cardView?.constrainBottomToSuperView(view.frame.size.height - initialCardFrame.origin.y - initialCardFrame.size.height)
        view.addConstraint(cardViewLeftConstraint!)
        view.addConstraint(cardViewTopConstraint!)
        view.addConstraint(cardViewRightConstraint!)
        view.addConstraint(cardViewBottomConstraint!)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    func cardViewWillReload(cardView: CardView) {

    }
    
    func cardViewDidReload(cardView: CardView) {
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cardView?.reloadWithCard(maximizedCard, datasource: maximizedCardDataSource)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(presented: UIViewController!, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController!) -> UIPresentationController! {
        
        if presented == self {
            return StockModalCardPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }else{
            return nil
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        
        if presented == self {
            return StockMaximizedCardAnimationController(isPresenting: true)
        }else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        
        if dismissed == self {
            return StockMaximizedCardAnimationController(isPresenting: false)
        }else {
            return nil
        }
    }
}
