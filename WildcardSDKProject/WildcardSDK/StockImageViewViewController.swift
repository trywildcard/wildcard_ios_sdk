//
//  StockImageViewViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/31/15.
//
//

import UIKit

class StockImageViewViewController: UIViewController,UIViewControllerTransitioningDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var scrollView:UIScrollView!
    var imageView:WCImageView!
    var fromCardView:CardView!
    var fromImageView:WCImageView!
    var tapGesture:UITapGestureRecognizer!
    var imagePanGesture:UIPanGestureRecognizer!
    var initialTouchPoint:CGPoint = CGPointZero
    var finalTouchPoint:CGPoint = CGPointZero
    let PAN_TO_DIMISS_THRESHOLD:CGFloat = 90.0;
    
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
        
        imagePanGesture = UIPanGestureRecognizer(target: self, action: "imagePanned")
        imagePanGesture.delegate = self
        scrollView.addGestureRecognizer(imagePanGesture)
        
        view.layoutIfNeeded()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func tapped(){
        if(self.scrollView.zoomScale != 1.0){
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.scrollView.zoomScale = 1.0
            })
        }else{
            fromCardView.delegate?.cardViewRequestedAction?(fromCardView, action: CardViewAction(type: .ImageWillExitFullScreen, parameters:nil))
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer == imagePanGesture && !otherGestureRecognizer.isKindOfClass(UIPinchGestureRecognizer)){
            return true
        }else{
            return false
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer == imagePanGesture){
            if(scrollView.zoomScale == 1.0){
                return true
            }else{
                return false
            }
        }else{
            return true
        }
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
    
    // MARK: Private
    func imagePanned(){
        // drags the image around when we are not zoomed
        let translation = imagePanGesture.translationInView(scrollView)
        if(imagePanGesture.state == .Began){
            initialTouchPoint = imagePanGesture.locationInView(scrollView)
        }else if(imagePanGesture.state == .Changed){
            let newCenter = CGPointMake(imageView.center.x + translation.x, imageView.center.y + translation.y)
            imageView.center = newCenter
            imagePanGesture.setTranslation(CGPointZero, inView: scrollView)
        }else{
            finalTouchPoint = imagePanGesture.locationInView(scrollView)
            let distance = distanceFromPoint(finalTouchPoint, toOtherPoint: initialTouchPoint)
            if(distance > PAN_TO_DIMISS_THRESHOLD){
                fromCardView.delegate?.cardViewRequestedAction?(fromCardView, action: CardViewAction(type: .ImageWillExitFullScreen, parameters:nil))
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }else{
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.imageView.frame = self.view.frame
                })
            }
        }
    }
    
    func distanceFromPoint(p1:CGPoint, toOtherPoint p2:CGPoint)->CGFloat{
        let xDist = (p2.x - p1.x);
        let yDist = (p2.y - p1.y);
        let distance = sqrt((xDist * xDist) + (yDist * yDist));
        return distance;
    }

}
