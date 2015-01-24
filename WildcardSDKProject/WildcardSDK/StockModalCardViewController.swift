//
//  StockModalCardViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/19/14.
//
//

import Foundation

class StockModalCardViewController : UIViewController, UIViewControllerTransitioningDelegate, CardViewDelegate,CardPhysicsDelegate
{
    var backgroundClearView:UIView?
    var backgroundTapRecognizer:UITapGestureRecognizer?
    var cardView:CardView?
    var presentedCard:Card!
    var cardVisualSource:CardViewVisualSource!
    var closeButton:UIButton!
    var closeButtonTopConstraint:NSLayoutConstraint!
    var currentOrientation:UIInterfaceOrientation!
    var initialOrientation:UIInterfaceOrientation!
    var cardViewVerticalConstraint:NSLayoutConstraint!
    var cardViewHorizontalConstraint:NSLayoutConstraint!
    var cardHeightConstraint:NSLayoutConstraint!
    var cardWidthConstraint:NSLayoutConstraint!
    
    // MARK: CardPhysicsDelegate
    func cardViewDropped(cardView: CardView, position: CGPoint) {
        
        // check if the card view has been dragged "out of bounds" in the view controller view(10% of edges)
        let viewBounds = view.bounds
        
        let horizontalThreshold = 0.10 * viewBounds.width
        let verticalThreshold = 0.10 * viewBounds.height
        
        // move left, right, up, or down
        if(position.x < horizontalThreshold){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint =  self.cardViewHorizontalConstraint {
                    constraint.constant = constraint.constant - viewBounds.width
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }else if(position.x > (view.bounds.width - horizontalThreshold)){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.cardViewHorizontalConstraint {
                    constraint.constant = constraint.constant + viewBounds.width
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }else if(position.y < verticalThreshold){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint =  self.cardViewVerticalConstraint{
                    constraint.constant = constraint.constant - viewBounds.height
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }else if(position.y > (view.bounds.height - verticalThreshold)){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.cardViewVerticalConstraint{
                    constraint.constant = constraint.constant + viewBounds.height
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }else{
            cardView.physics?.panGestureReset()
        }
    }
    
    // MARK: UIViewController
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        closeButton.setImage(UIImage.loadFrameworkImage("closeIcon"), forState: UIControlState.Normal)
        closeButton.tintColor = UIColor.whiteColor()
        view.addSubview(closeButton)
        closeButtonTopConstraint = closeButton.constrainTopToSuperView(0)
        closeButton.constrainLeftToSuperView(0)
        closeButton.constrainWidth(50, height: 50)
        closeButton.addTarget(self, action: "closeButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        // init card view
        cardView = CardView.createCardView(presentedCard, visualSource: cardVisualSource)
        cardView?.delegate = self
        cardView?.physics?.enableDragging = true
        cardView?.physics?.delegate = self
        
        // constrain card view at the bottom controller view to start
        view.addSubview(cardView!)
        cardHeightConstraint = cardView?.constrainHeight(cardView!.frame.size.height)
        cardWidthConstraint = cardView?.constrainWidth(cardView!.frame.size.width)
        cardViewVerticalConstraint = cardView?.verticallyCenterToSuperView(view.frame.size.height)
        cardViewHorizontalConstraint = cardView?.horizontallyCenterToSuperView(0)
        
        backgroundClearView = UIView(frame:CGRectZero)
        view.insertSubview(backgroundClearView!, belowSubview: cardView!)
        backgroundClearView?.constrainToSuperViewEdges()
        backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapped")
        backgroundClearView!.addGestureRecognizer(backgroundTapRecognizer!)
        
        currentOrientation = UIApplication.sharedApplication().statusBarOrientation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        initialOrientation = currentOrientation
        
        if(UIApplication.sharedApplication().statusBarHidden){
            closeButtonTopConstraint.constant = 0
        }else{
            closeButtonTopConstraint.constant = 15
        }
        
        view.layoutIfNeeded()
    }
    
    // MARK: CardViewDelegate
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        handleCardAction(cardView, action: action)
    }
    
    func cardViewWillLayoutToNewSize(cardView: CardView, fromSize: CGSize, toSize: CGSize) {
        cardHeightConstraint.constant = toSize.height
        cardWidthConstraint.constant = toSize.width
    }
    
    // MARK: Action Handlers
    func handleOrientationChange(notification:NSNotification){
        if(UIApplication.sharedApplication().statusBarOrientation != currentOrientation){
            currentOrientation = UIApplication.sharedApplication().statusBarOrientation
            
            if(currentOrientation == initialOrientation){
                cardView?.reloadWithCard(presentedCard, visualSource: cardVisualSource)
            }else{
                cardView?.reloadWithCard(presentedCard)
            }
            
            if(UIApplication.sharedApplication().statusBarHidden){
                closeButtonTopConstraint.constant = 0
            }else{
                closeButtonTopConstraint.constant = 15
            }
        }
    }
    
    func closeButtonTapped(){
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
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