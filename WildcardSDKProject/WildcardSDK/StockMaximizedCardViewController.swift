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
    
    var presentingControllerBackgroundView:UIView?
    var presentingCardView:CardView!
    var maximizedCard:Card!
    var maximizedCardView:CardView?
    var maximizedCardVisualSource:MaximizedCardViewVisualSource!
    
    var cardViewTopConstraint:NSLayoutConstraint?
    var cardViewBottomConstraint:NSLayoutConstraint?
    var cardViewLeftConstraint:NSLayoutConstraint?
    var cardViewRightConstraint:NSLayoutConstraint?
    
    var initialCardFrame:CGRect!
    var initialCardVisualSource:CardViewVisualSource!
    var finishedLoadAnimation = false
    
    func cardViewRequestedAction(cardView: CardView, action: CardViewAction) {
        if(action.type == .Collapse){
            maximizedCardView?.fadeOut(0.2, delay: 0, completion: nil)
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }else if(action.type == .DownloadApp){
            if let actionParams = action.parameters{
                let id = actionParams["id"] as NSString
                var parameters = NSMutableDictionary()
                parameters[SKStoreProductParameterITunesItemIdentifier] = id.integerValue
                
                var storeController = SKStoreProductViewController()
                storeController.delegate = self
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                storeController.loadProductWithParameters(parameters, completionBlock: { (bool:Bool, error:NSError!) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.presentViewController(storeController, animated: true, completion: nil)
                    return
                })
            }
        }else if(action.type == .Action){
            if let actionParams = action.parameters{
                let url = actionParams["url"] as NSURL
                let activityItems:[AnyObject] = [url]
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                presentViewController(activityViewController, animated: true, completion: nil)
            }
        }
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
        
        maximizedCardView = CardView.createCardView(maximizedCard, visualSource: initialCardVisualSource)
        maximizedCardView?.delegate = self
        maximizedCardView!.frame = initialCardFrame
        
        view.addSubview(maximizedCardView!)
        
        //initiailize constraints
        cardViewLeftConstraint = maximizedCardView?.constrainLeftToSuperView(initialCardFrame.origin.x)
        cardViewTopConstraint = maximizedCardView?.constrainTopToSuperView(initialCardFrame.origin.y)
        cardViewRightConstraint = maximizedCardView?.constrainRightToSuperView(view.frame.size.width - initialCardFrame.origin.x - initialCardFrame.size.width)
        cardViewBottomConstraint = maximizedCardView?.constrainBottomToSuperView(view.frame.size.height - initialCardFrame.origin.y - initialCardFrame.size.height)
        view.addConstraint(cardViewLeftConstraint!)
        view.addConstraint(cardViewTopConstraint!)
        view.addConstraint(cardViewRightConstraint!)
        view.addConstraint(cardViewBottomConstraint!)
        maximizedCardView?.fadeOut(0, delay: 0, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.maximizedCardView?.reloadWithCard(self.maximizedCard, visualSource: self.maximizedCardVisualSource)
        
        if(!finishedLoadAnimation){
            self.maximizedCardView?.reloadWithCard(self.maximizedCard, visualSource: self.maximizedCardVisualSource)
            maximizedCardView?.fadeOut(0, delay: 0, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(!finishedLoadAnimation){
            maximizedCardView?.fadeIn(0.2, delay: 0, completion: nil)
            finishedLoadAnimation = true
        }
    }
    
    func cardViewWillReload(cardView: CardView) {
    }
    
    func cardViewDidReload(cardView: CardView) {
    }
    
    // MARK: SKStoreProductViewControllerDelegate
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(presented: UIViewController!, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController!) -> UIPresentationController! {
        
        if presented == self {
            let presentationController = StockMaximizedCardPresentationController(presentedViewController: presented, presentingViewController: presenting)
            presentationController.presentingCardView = presentingCardView
            return presentationController
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
