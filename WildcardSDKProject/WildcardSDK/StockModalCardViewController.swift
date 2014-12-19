//
//  StockModalCardViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/19/14.
//
//

import Foundation

class StockModalCardViewController : UIViewController, UIViewControllerTransitioningDelegate, CardPhysicsDelegate
{
    var backgroundClearView:UIView?
    var backgroundTapRecognizer:UITapGestureRecognizer?
    var cardView:CardView?
    var presentedCard:Card!
    var cardDataSource:CardViewDataSource!
    var cardViewVerticalConstraint:NSLayoutConstraint?

    // MARK: CardPhysicsDelegate
    func cardViewDropped(cardView: CardView, position: CGPoint) {
        cardView.physics?.panGestureReset()
    }
    
    // MARK: UIViewController
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView = CardView.createCardView(presentedCard, datasource: cardDataSource)
        cardView?.physics?.enableDragging = true
        cardView?.physics?.delegate = self
        
        // constrain card at the bottom controller view
        view.addSubview(cardView!)
        cardView?.constrainWidth(cardView!.frame.size.width, andHeight: cardView!.frame.size.height)
        cardViewVerticalConstraint = cardView?.verticallyCenterToSuperView(view.frame.size.height)
        cardView?.horizontallyCenterToSuperView(0)
        view.layoutIfNeeded()
        
        backgroundClearView = UIView(frame:CGRectZero)
        view.insertSubview(backgroundClearView!, belowSubview: cardView!)
        backgroundClearView?.constrainToSuperViewEdges()
        backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapped")
        backgroundClearView!.addGestureRecognizer(backgroundTapRecognizer!)
    }
    
    // MARK: Private
    func backgroundTapped(){
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
            return StockModalCardAnimationController(isPresenting: true)
        }else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {

        if dismissed == self {
            return StockModalCardAnimationController(isPresenting: false)
        }else {
            return nil
        }
    }
}