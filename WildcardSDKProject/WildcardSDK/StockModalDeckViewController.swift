//
//  StockModalDeckViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/19/14.
//
//

import Foundation

class StockModalDeckViewController : UIViewController, UIViewControllerTransitioningDelegate, CardViewDelegate, CardPhysicsDelegate
{
    struct ConstraintContainer{
        var centerX:NSLayoutConstraint
        var centerY:NSLayoutConstraint
        var width:NSLayoutConstraint
        var height:NSLayoutConstraint
    }
    
    let BACKCARD_VERTICAL_OFFSET:CGFloat = 12
    let BACKCARD_SCALE:CGFloat = 0.97
    let HIDDENCARD_SCALE:CGFloat = 0.94
    let DRAG_TRANSFORM_THRESHOLD:CGFloat = 140
    
    var backgroundClearView:UIView?
    var backgroundTapRecognizer:UITapGestureRecognizer?
    var cards:[Card] = []
    var frontCardCenter:CGPoint = CGPointZero
    
    var visibleCardViews:[CardView] = []
    var visibleCardConstraintContainers:[ConstraintContainer] = []
    var frontCardIndex:Int = 0
    var closeButton:UIButton!
    
    // MARK: CardViewDelegate
    func cardViewRequestedMaximize(cardView: CardView) {
        if(cardView.backingCard.type == .WCCardTypeArticle){
            maximizeArticleCard(cardView)
        }
    }
    
    // MARK: CardPhysicsDelegate
    func cardViewDropped(cardView: CardView, position: CGPoint) {
        
        // check if the card view has been dragged "out of bounds" in the view controller view(10% of edges)
        let viewBounds = view.bounds
        
        let horizontalThreshold = 0.10 * viewBounds.width
        let verticalThreshold = 0.10 * viewBounds.height
        
        // move left, right, up, or down
        if(position.x < horizontalThreshold){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    let constraint = self.visibleCardConstraintContainers[0].centerX
                    constraint.constant = constraint.constant - viewBounds.width
                    self.view.layoutIfNeeded()
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
            
        }else if(position.x > (view.bounds.width - horizontalThreshold)){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    let constraint = self.visibleCardConstraintContainers[0].centerX
                    constraint.constant = constraint.constant + viewBounds.width
                    self.view.layoutIfNeeded()
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
            
        }else if(position.y < verticalThreshold){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    let constraint = self.visibleCardConstraintContainers[0].centerY
                    constraint.constant = constraint.constant - viewBounds.height
                    self.view.layoutIfNeeded()
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
            
        }else if(position.y > (view.bounds.height - verticalThreshold)){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    let constraint = self.visibleCardConstraintContainers[0].centerY
                    constraint.constant = constraint.constant + viewBounds.height
                    self.view.layoutIfNeeded()
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
        }else{
            cardView.physics?.panGestureReset()
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.visibleCardViews[1].transform =   CGAffineTransformMakeScale(self.BACKCARD_SCALE,self.BACKCARD_SCALE)
                }){ (bool:Bool) -> Void in
                    return
            }
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.visibleCardViews[2].transform =   CGAffineTransformMakeScale(self.HIDDENCARD_SCALE, self.HIDDENCARD_SCALE)
                }){ (bool:Bool) -> Void in
                    return
            }
        }
        
    }
    
    func cardViewDragged(cardView: CardView, position: CGPoint) {
        let xDiff = position.x - frontCardCenter.x
        let yDiff = position.y - frontCardCenter.y
        
        var distanceFromCenter:CGFloat = sqrt((xDiff * xDiff) + (yDiff * yDiff))
        var percentage:CGFloat = min(distanceFromCenter, DRAG_TRANSFORM_THRESHOLD) / DRAG_TRANSFORM_THRESHOLD
        
        let yTranslate:CGFloat = (BACKCARD_VERTICAL_OFFSET * percentage)
        let scale:CGFloat = BACKCARD_SCALE + (0.03 * percentage)
        
        let translation:CGAffineTransform = CGAffineTransformMakeScale(scale,scale)
        let translation2:CGAffineTransform = CGAffineTransformMakeTranslation(0, -yTranslate)
        let secondCardView = visibleCardViews[1]
        secondCardView.transform = CGAffineTransformConcat(translation, translation2)
        
        let scale2:CGFloat = HIDDENCARD_SCALE + (0.03 * percentage)
        let translation3:CGAffineTransform = CGAffineTransformMakeScale(scale2, scale2)
        let translation4:CGAffineTransform = CGAffineTransformMakeTranslation(0, 0)
        let thirdCardView = visibleCardViews[2]
        thirdCardView.transform = CGAffineTransformConcat(translation3, translation4)
    }
    
    func setupNextCard(){
        
        visibleCardViews.removeAtIndex(0)
        visibleCardConstraintContainers.removeAtIndex(0)
        
        frontCardIndex = incrIndex(frontCardIndex,amount: 1)
        
        // front
        let frontCardContainer = visibleCardConstraintContainers[0]
        frontCardContainer.centerY.constant = 0
        let frontCardView = visibleCardViews[0]
        frontCardView.delegate = self
        frontCardView.physics?.delegate = self
        frontCardView.physics?.enableDragging = true
        frontCardView.transform = CGAffineTransformMakeScale(1, 1)
        
        // middle
        let middleCard = cards[incrIndex(frontCardIndex, amount: 1)]
        let middleCardContainer = visibleCardConstraintContainers[1]
        let secondCardView = visibleCardViews[1]
        secondCardView.reloadWithCard(middleCard)
        middleCardContainer.centerY.constant = BACKCARD_VERTICAL_OFFSET
        secondCardView.transform = CGAffineTransformMakeScale(BACKCARD_SCALE, BACKCARD_SCALE)
        
        // back
        let dummyView = CardView(frame: CGRectZero)
        dummyView.frame = frontCardView.frame
        view.insertSubview(dummyView, belowSubview: secondCardView)
        let container3 = fullyConstrainCardView(dummyView)
        container3.centerY.constant = BACKCARD_VERTICAL_OFFSET
        dummyView.transform = CGAffineTransformMakeScale(HIDDENCARD_SCALE, HIDDENCARD_SCALE)
        
        visibleCardViews.append(dummyView)
        visibleCardConstraintContainers.append(container3)
        
    }
    func closeButtonTapped(){
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK:UIViewController
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        closeButton.setImage(UIImage(named: "closeIcon"), forState: UIControlState.Normal)
        view.addSubview(closeButton)
        closeButton.constrainTopToSuperView(15)
        closeButton.constrainLeftToSuperView(0)
        closeButton.constrainWidth(50, height: 50)
        closeButton.addTarget(self, action: "closeButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // Initialize Front Card
        let frontCard = cards[frontCardIndex]
        let firstCardView = CardView.createCardView(frontCard)
        firstCardView?.delegate = self
        view.addSubview(firstCardView!)
        let container = fullyConstrainCardView(firstCardView!)
        visibleCardViews.append(firstCardView!)
        visibleCardConstraintContainers.append(container)
        
        // second
        let secondCard = cards[frontCardIndex + 1]
        let secondCardView = CardView.createCardView(secondCard)
        view.insertSubview(secondCardView!, belowSubview:firstCardView!)
        let container2 = fullyConstrainCardView(secondCardView!)
        secondCardView?.transform = CGAffineTransformMakeScale(BACKCARD_SCALE, BACKCARD_SCALE)
        container2.centerY.constant = BACKCARD_VERTICAL_OFFSET
        
        visibleCardViews.append(secondCardView!)
        visibleCardConstraintContainers.append(container2)
        
        let dummyView = CardView(frame: CGRectZero)
        dummyView.frame = firstCardView!.frame
        
        view.insertSubview(dummyView, belowSubview: secondCardView!)
        let container3 = fullyConstrainCardView(dummyView)
        container3.centerY.constant = BACKCARD_VERTICAL_OFFSET
        
        dummyView.transform = CGAffineTransformMakeScale(HIDDENCARD_SCALE, HIDDENCARD_SCALE)
        
        visibleCardViews.append(dummyView)
        visibleCardConstraintContainers.append(container3)
        
        backgroundClearView = UIView(frame:CGRectZero)
        view.insertSubview(backgroundClearView!, atIndex:0)
        backgroundClearView?.constrainToSuperViewEdges()
        backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapped")
        backgroundClearView!.addGestureRecognizer(backgroundTapRecognizer!)
        
        firstCardView?.physics?.delegate = self
        firstCardView?.physics?.enableDragging = true
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        frontCardCenter = visibleCardViews[0].center
    }
    
    private func fullyConstrainCardView(cardView:CardView)->ConstraintContainer{
        let centerX = cardView.horizontallyCenterToSuperView(0)
        let centerY = cardView.verticallyCenterToSuperView(0)
        let height = cardView.constrainHeight(cardView.frame.size.height)
        let width = cardView.constrainWidth(cardView.frame.size.width)
        return  ConstraintContainer(centerX: centerX, centerY: centerY, width: width, height: height)
    }
    
    func backgroundTapped(){
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func incrIndex(index:Int, amount:Int)->Int{
        return (index + amount) % cards.count
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
            return StockModalDeckAnimationController(isPresenting: true)
        }else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        
        if dismissed == self {
            return StockModalDeckAnimationController(isPresenting: false)
        }else {
            return nil
        }
    }
}