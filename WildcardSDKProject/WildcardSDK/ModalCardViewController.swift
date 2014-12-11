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
        cardView?.physics?.enableDragging = true
        cardView?.physics?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // pop up the card
        if(cardView != nil){
            cardView!.center = CGPointMake(view.frame.size.width/2, view.frame.size.height + cardView!.frame.size.height)
            view.addSubview(cardView!)
            
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.cardView!.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
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
                 self.cardView!.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height + self.cardView!.frame.size.height)
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
