//
//  ModalMaximizedCardViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/18/14.
//
//

import UIKit
import StoreKit

class StockMaximizedCardViewController: UIViewController, CardPhysicsDelegate, CardViewDelegate,UIViewControllerTransitioningDelegate, SKStoreProductViewControllerDelegate {
    
    var presentingCardView:CardView!
    var maximizedCard:Card!
    var maximizedCardView:CardView!
    var maximizedCardVisualSource:MaximizedCardViewVisualSource!
    
    var cardViewTopConstraint:NSLayoutConstraint?
    var cardViewBottomConstraint:NSLayoutConstraint?
    var cardViewLeftConstraint:NSLayoutConstraint?
    var cardViewRightConstraint:NSLayoutConstraint?
    
    var initialCardFrame:CGRect!
    var finishedLoadAnimation = false
    var currentOrientation:UIInterfaceOrientation!
    
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        if(action.type == .Collapse){
            // before collapse, re calc original frame
            initialCardFrame = self.view.convertRect(presentingCardView.frame, fromView: presentingCardView.superview)
        }
        handleCardAction(cardView, action: action)
    }
    
    // MARK:UIViewController
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maximizedCardView = CardView.createCardView(maximizedCard, visualSource: maximizedCardVisualSource, preferredWidth:UIViewNoIntrinsicMetric)
        maximizedCardView.delegate = self
        
        view.addSubview(maximizedCardView!)
        
        initialCardFrame = presentingViewController!.view.convertRect(presentingCardView.frame, fromView: presentingCardView.superview)
        
        //initiailize constraints
        cardViewLeftConstraint = maximizedCardView?.constrainLeftToSuperView(initialCardFrame.origin.x)
        cardViewTopConstraint = maximizedCardView?.constrainTopToSuperView(initialCardFrame.origin.y)
        cardViewRightConstraint = maximizedCardView?.constrainRightToSuperView(view.frame.size.width - initialCardFrame.origin.x - initialCardFrame.size.width)
        cardViewBottomConstraint = maximizedCardView?.constrainBottomToSuperView(view.frame.size.height - initialCardFrame.origin.y - initialCardFrame.size.height)
        maximizedCardView?.fadeOut(0, delay: 0, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(!finishedLoadAnimation){
            maximizedCardView?.fadeIn(0.3, delay: 0, completion: nil)
            finishedLoadAnimation = true
        }
        
        currentOrientation = UIApplication.sharedApplication().statusBarOrientation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func handleOrientationChange(notification:NSNotification){
        if(UIApplication.sharedApplication().statusBarOrientation != currentOrientation){
            currentOrientation = UIApplication.sharedApplication().statusBarOrientation
            maximizedCardView?.reloadWithCard(maximizedCard, visualSource: maximizedCardVisualSource, preferredWidth:UIViewNoIntrinsicMetric)
            let destination = calculateMaximizedFrame()
            updateInternalCardConstraints(destination)
        }
    }
    
    func calculateMaximizedFrame() -> CGRect{
        // insets relative to the application frame
        let applicationInsets = maximizedCardVisualSource.applicationFrameEdgeInsets()
        let applicationFrame = UIScreen.mainScreen().applicationFrame
        
        // this is the card frame in the coordinate space of the application frame / main screen
        let cardFrame = CGRectMake(applicationFrame.origin.x + applicationInsets.left, applicationFrame.origin.y + applicationInsets.top, applicationFrame.width - applicationInsets.left - applicationInsets.right, applicationFrame.height - applicationInsets.top - applicationInsets.bottom)
        
        // convert to a rectangle in view controller space
        let rectConvert = view.convertRect(cardFrame, fromCoordinateSpace: UIScreen.mainScreen().coordinateSpace)
        return rectConvert
    }
    
    func updateInternalCardConstraints(destination:CGRect){
        cardViewLeftConstraint?.constant = destination.origin.x
        cardViewTopConstraint?.constant = destination.origin.y
        cardViewRightConstraint?.constant = view.frame.size.width - destination.origin.x - destination.width
        cardViewBottomConstraint?.constant = view.frame.size.height - destination.origin.y - destination.height
        view.layoutIfNeeded()
    }
    
    // MARK: SKStoreProductViewControllerDelegate
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            let presentationController = StockMaximizedCardPresentationController(presentedViewController: presented, presentingViewController: presenting)
            presentationController.presentingCardView = presentingCardView
            return presentationController
        }else{
            return nil
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return StockMaximizedCardAnimationController(isPresenting: true)
        }else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return StockMaximizedCardAnimationController(isPresenting: false)
        }else {
            return nil
        }
    }
}
