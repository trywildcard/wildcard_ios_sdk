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
    
    var backgroundClearView:UIView?
    var backgroundTapRecognizer:UITapGestureRecognizer?
    var cards:[Card] = []
    var frontCardCenter:CGPoint = CGPointZero
    
    var visibleCardViews:[CardView] = []
    var visibleCardConstraintContainers:[ConstraintContainer] = []
    var frontCardIndex:Int = 0
    
    // MARK: CardViewDelegate
    func cardViewRequestedMaximize(cardView: CardView) {
        maximizeCardView(cardView)
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
                self.visibleCardViews[2].transform =   CGAffineTransformMakeScale(self.BACKCARD_SCALE,self.BACKCARD_SCALE)
                }){ (bool:Bool) -> Void in
                    return
            }
        }
        
    }
    
    func cardViewDragged(cardView: CardView, position: CGPoint) {
        let xDiff = position.x - frontCardCenter.x
        let yDiff = position.y - frontCardCenter.y
        
        let THRESHOLD:CGFloat = 140
        var distanceFromCenter:CGFloat = sqrt((xDiff * xDiff) + (yDiff * yDiff))
        distanceFromCenter = min(distanceFromCenter,THRESHOLD)
        var percentage:CGFloat = distanceFromCenter / THRESHOLD
        println(percentage)
        
        let yTranslate:CGFloat = (BACKCARD_VERTICAL_OFFSET * percentage)
        let scale:CGFloat = BACKCARD_SCALE + (0.03 * percentage)
        
        let translation:CGAffineTransform = CGAffineTransformMakeScale(scale,scale)
        let translation2:CGAffineTransform = CGAffineTransformMakeTranslation(0, -yTranslate)
        let secondCardView = visibleCardViews[1]
        secondCardView.transform = CGAffineTransformConcat(translation, translation2)
        
        let translation3:CGAffineTransform = CGAffineTransformMakeScale(BACKCARD_SCALE,BACKCARD_SCALE)
        let translation4:CGAffineTransform = CGAffineTransformMakeTranslation(0, yTranslate)
        let thirdCardView = visibleCardViews[2]
        thirdCardView.transform = CGAffineTransformConcat(translation3, translation4)
    }
    
    func setupNextCard(){
        
        visibleCardViews.removeAtIndex(0)
        visibleCardConstraintContainers.removeAtIndex(0)
        
        // update current index
        frontCardIndex = incrIndex(frontCardIndex,amount: 1)
        
        // init physics, etc. on front card
        let frontCardContainer = visibleCardConstraintContainers[0]
        frontCardContainer.centerY.constant = 0
        let frontCardView = visibleCardViews[0]
        frontCardView.physics?.delegate = self
        frontCardView.physics?.enableDragging = true
        frontCardView.transform = CGAffineTransformMakeScale(1, 1)
        
        // middle
        let middleCardContainer = visibleCardConstraintContainers[1]
        let secondCardView = visibleCardViews[1]
        middleCardContainer.centerY.constant = BACKCARD_VERTICAL_OFFSET
        secondCardView.transform = CGAffineTransformMakeScale(BACKCARD_SCALE, BACKCARD_SCALE)
        
        // set up new back card
        let thirdCard = cards[incrIndex(frontCardIndex, amount: 2)]
        let thirdCardView = CardView.createCardView(thirdCard)
        thirdCardView?.delegate = self
        view.insertSubview(thirdCardView!, belowSubview:secondCardView)
        let newContainer = fullyConstrainCardView(thirdCardView!)
        
        thirdCardView?.transform = CGAffineTransformMakeScale(BACKCARD_SCALE, BACKCARD_SCALE)
        
        visibleCardViews.append(thirdCardView!)
        visibleCardConstraintContainers.append(newContainer)
    }
    
    
    // MARK:UIViewController
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapped")
        
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
        secondCardView?.delegate = self
        view.insertSubview(secondCardView!, belowSubview:firstCardView!)
        let container2 = fullyConstrainCardView(secondCardView!)
        
        secondCardView?.transform = CGAffineTransformMakeScale(BACKCARD_SCALE, BACKCARD_SCALE)
        container2.centerY.constant = BACKCARD_VERTICAL_OFFSET
        
        visibleCardViews.append(secondCardView!)
        visibleCardConstraintContainers.append(container2)
        
        let thirdCard = cards[frontCardIndex + 2]
        let thirdCardView = CardView.createCardView(thirdCard)
        thirdCardView?.delegate = self
        view.insertSubview(thirdCardView!, belowSubview:secondCardView!)
        let container3 = fullyConstrainCardView(thirdCardView!)
        
        thirdCardView?.transform = CGAffineTransformMakeScale(BACKCARD_SCALE, BACKCARD_SCALE)
        
        visibleCardViews.append(thirdCardView!)
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
    
    // MARK: Private
    func fullyConstrainCardView(cardView:CardView)->ConstraintContainer{
        let centerX = cardView.horizontallyCenterToSuperView(0)
        let centerY = cardView.verticallyCenterToSuperView(0)
        let height = cardView.constrainHeight(cardView.frame.size.height)
        let width = cardView.constrainWidth(cardView.frame.size.width)
        return  ConstraintContainer(centerX: centerX, centerY: centerY, width: width, height: height)
    }
    
    func backgroundTapped(){
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func incrIndex(index:Int, amount:Int)->Int{
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