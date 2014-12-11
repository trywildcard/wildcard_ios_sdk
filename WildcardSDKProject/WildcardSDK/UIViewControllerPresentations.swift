//
//  UIViewControllerPresentations.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

public extension UIViewController{
    
    public func presentCard(card:Card){
        let modalViewController = ModalCardViewController()
        
        let snapShot:UIView = view.snapshotViewAfterScreenUpdates(false)
        modalViewController.view.insertSubview(snapShot, atIndex:0)
        
        modalViewController.presentingControllerBackgroundView = snapShot
        modalViewController.blurredOverlayView = snapShot.addBlurOverlay(UIBlurEffectStyle.Dark)
        modalViewController.blurredOverlayView!.alpha = 0
        modalViewController.presentedCard = card
        modalViewController.cardView = CardView.createCardViewFromCard(card)
        
        presentViewController(modalViewController, animated: false, completion: nil)
    }
}