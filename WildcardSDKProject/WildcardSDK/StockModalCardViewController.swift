//
//  StockModalCardViewController.swift
//  WildcardSDKProject
//
//  Created by Lacy Rhoades on 10/7/15.
//

import Foundation

class StockModalCardViewController: UIViewController, UIViewControllerTransitioningDelegate, CardViewDelegate, CardPhysicsDelegate {
    var backgroundView: UIView!
    var presentedCard: Card!
    var cardVisualSource: CardViewVisualSource!
    
    var cardView: CardView!
    var cardViewVerticalConstraint: NSLayoutConstraint!
    var cardViewHorizontalConstraint: NSLayoutConstraint!
    
    var closeButton: UIButton!
    var closeButtonTopConstraint: NSLayoutConstraint!
    var currentOrientation: UIInterfaceOrientation!
    var initialOrientation: UIInterfaceOrientation!
    
    override func viewDidLoad() {
        backgroundView = UIView(frame:CGRectZero)
        let tap = UITapGestureRecognizer(target: self, action: "dismiss")
        backgroundView.addGestureRecognizer(tap)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundView)
        
        cardView = CardView.createCardView(presentedCard, visualSource: cardVisualSource, preferredWidth:UIViewNoIntrinsicMetric)
        cardView.delegate = self
        cardView.physics?.enableDragging = true
        cardView.physics?.delegate = self
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cardView)
        
        cardViewVerticalConstraint = NSLayoutConstraint(item: cardView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(cardViewVerticalConstraint)
        cardViewHorizontalConstraint = NSLayoutConstraint(item: cardView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(cardViewHorizontalConstraint)
        
        closeButton = UIButton(type: .Custom)
        closeButton.setImage(UIImage.loadFrameworkImage("closeIcon"), forState: UIControlState.Normal)
        closeButton.tintColor = UIColor.whiteColor()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        closeButtonTopConstraint = NSLayoutConstraint(item: closeButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        self.view.addConstraint(closeButtonTopConstraint)
        
        closeButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        self.handleOrientationChange(NSNotification(name: "", object: nil))
        initialOrientation = currentOrientation
        
        let metrics = ["margin": 10];
        
        let views = ["cardView": cardView, "backgroundView": backgroundView];
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundView]|", options: [], metrics: metrics, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundView]|", options: [], metrics: metrics, views: views))
        
        self.view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 50))
        self.view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 50))
    }
    
    func dismiss() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func handleOrientationChange(notification:NSNotification){
        if(UIApplication.sharedApplication().statusBarOrientation != currentOrientation){
            currentOrientation = UIApplication.sharedApplication().statusBarOrientation
            
            if(UIApplication.sharedApplication().statusBarHidden){
                closeButtonTopConstraint.constant = 0
            }else{
                closeButtonTopConstraint.constant = 15
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return StockModalCardPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }else{
            return nil
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == self {
            return StockModalCardAnimationController(isPresenting: true)
        }else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self {
            return StockModalCardAnimationController(isPresenting: false)
        }else {
            return nil
        }
    }
    
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        handleCardAction(cardView, action: action)
    }
    
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
}
