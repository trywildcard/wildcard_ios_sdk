//
//  StockImageViewViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/31/15.
//
//

import UIKit

class StockImageViewViewController: UIViewController,UIViewControllerTransitioningDelegate, UIScrollViewDelegate {
    
    var scrollView:UIScrollView!
    var imageView:WCImageView!
    var fromCardView:CardView!
    var fromImageView:WCImageView!
    var tapGesture:UITapGestureRecognizer!
    var doubleTapGesture:UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        // scroll view for zooming
        scrollView = UIScrollView(frame: CGRectZero)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.delegate = self
        scrollView.multipleTouchEnabled = true
        scrollView.bounces = true
        scrollView.bouncesZoom = true
        scrollView.maximumZoomScale = 5;
        scrollView.minimumZoomScale = 1;
        view.addSubview(scrollView)
        scrollView.constrainToSuperViewEdges()

        // main image view
        imageView = WCImageView(frame: CGRectZero)
        imageView.image = fromImageView.image
        imageView.backgroundColor = UIColor.clearColor()
        imageView.userInteractionEnabled = false
        scrollView.addSubview(imageView)
        imageView.constrainToSuperViewEdges()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0))
        
        // gesture recognizers
        tapGesture = UITapGestureRecognizer(target: self, action: "tapped")
        scrollView.addGestureRecognizer(tapGesture!)
        
        doubleTapGesture = UITapGestureRecognizer(target: self, action: "doubleTapped")
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        tapGesture.requireGestureRecognizerToFail(doubleTapGesture)
        
        view.layoutIfNeeded()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func tapped(){
        if(self.scrollView.zoomScale != 1.0){
            doubleTapped()
        }else{
            fromCardView.delegate?.cardViewRequestedAction?(fromCardView, action: CardViewAction(type: .ImageWillExitFullScreen, parameters:nil))
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func doubleTapped(){
        if(self.scrollView.zoomScale == 1.0){
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.scrollView.zoomScale = 2.5
            })
        }else{
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.scrollView.zoomScale = 1.0
            })
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return StockImageViewPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }else{
            return nil
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return StockImageViewAnimationController(isPresenting: true)
        }else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return StockImageViewAnimationController(isPresenting: false)
        }else {
            return nil
        }
    }

}
