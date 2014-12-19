//
//  ModalMaximizedCardViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/18/14.
//
//

import UIKit

class ModalMaximizedCardViewController: UIViewController, CardPhysicsDelegate, CardViewDelegate {
    
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
        cardView.reloadWithCard(maximizedCard, datasource: initialCardDataSource)
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
        
        
        if(!loaded){
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.cardViewLeftConstraint?.constant = 10
                self.cardViewTopConstraint?.constant = 25
                self.cardViewRightConstraint?.constant = 10
                self.cardViewBottomConstraint?.constant = 10
                self.view.layoutIfNeeded()
            })
        }else{
      
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.cardViewLeftConstraint?.constant = self.initialCardFrame.origin.x
                self.cardViewTopConstraint?.constant = self.initialCardFrame.origin.y
                self.cardViewRightConstraint?.constant = (self.view.frame.size.width - self.initialCardFrame.origin.x - self.initialCardFrame.size.width)
                self.cardViewBottomConstraint?.constant = (self.view.frame.size.height - self.initialCardFrame.origin.y - self.initialCardFrame.size.height)
                self.view.layoutIfNeeded()
                
                }) { (bool:Bool) -> () in
                    
                    
                    self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
                    return
            }
        }


    }
    
    func cardViewDidReload(cardView: CardView) {
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        cardView?.reloadWithCard(maximizedCard, datasource: maximizedCardDataSource)
        
        loaded = true
        
        // maximize card
        
        
        // blur background
        if(blurredOverlayView != nil){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.blurredOverlayView!.alpha = 0.95
            })
        }
    }
    
    // MARK: Private
    func backgroundTapped(){

        
        // unblur
        if(blurredOverlayView != nil){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.blurredOverlayView!.alpha = 0
                }, completion: {(bool:Bool) -> Void in
                    self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
            })
        }
    }
}
