//
//  ModalCardViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import UIKit

class ModalCardViewController: UIViewController, CardPhysicsDelegate {
    
    var presentingControllerBackgroundView:UIView?
    var blurredOverlayView:UIView?
    var cardView:CardView?
    var presentedCard:Card!
    var backgroundTapRecognizer:UITapGestureRecognizer?
    var cardDataSource:CardViewDataSource!
    var cardViewVerticalConstraint:NSLayoutConstraint?
    
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
        backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapped")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presentingControllerBackgroundView?.addGestureRecognizer(backgroundTapRecognizer!)
        cardView = CardView.createCardView(presentedCard, datasource: cardDataSource)
        cardView?.physics?.enableDragging = true
        cardView?.physics?.delegate = self
        
        // constrain card to this controller view
        view.addSubview(cardView!)
        cardView?.constrainWidth(cardView!.frame.size.width, andHeight: cardView!.frame.size.height)
        cardViewVerticalConstraint = cardView?.verticallyCenterToSuperView(view.frame.size.height)
        cardView?.horizontallyCenterToSuperView(0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // pop up the card
        if(cardView != nil){
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.cardViewVerticalConstraint!.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        // blur background
        if(blurredOverlayView != nil){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.blurredOverlayView!.alpha = 0.95
            })
        }
    }
    
    // MARK: Private
    func backgroundTapped(){
        
        // move card down
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.cardViewVerticalConstraint!.constant = self.view.frame.size.height
                self.view.layoutIfNeeded()
            }, { (bool:Bool) -> Void in
        })
        
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
