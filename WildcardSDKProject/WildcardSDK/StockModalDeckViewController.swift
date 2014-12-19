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
    
    var backgroundClearView:UIView?
    var backgroundTapRecognizer:UITapGestureRecognizer?
    var cards:[Card] = []
    var frontCardCenter:CGPoint = CGPointZero
    
    var visibleCardViews:[CardView] = []
    var visibleCardConstraintContainers:[ConstraintContainer] = []
    var frontCardIndex = 0
    
    //var visibleCards:[Card] = []
    
    /*
    var frontCard:Card?
    var backCard:Card?
    var frontCardView:CardView?
    var backCardView:CardView?
    var currentCardIndex:Int = 0
    
    var frontCardCenterX:NSLayoutConstraint?
    var frontCardCenterY:NSLayoutConstraint?
    var backCardCenterX:NSLayoutConstraint?
    var backCardCenterY:NSLayoutConstraint?
*/
    
    // MARK: CardViewDelegate
    func cardViewRequestedMaximize(cardView: CardView) {
        maximizeCardView(cardView)
    }
    
    // MARK: CardPhysicsDelegate
    func cardViewDropped(cardView: CardView, position: CGPoint) {
        
        /*
        // check if the card view has been dragged "out of bounds" in the view controller view(10% of edges)
        let viewBounds = view.bounds
        
        let horizontalThreshold = 0.10 * viewBounds.width
        let verticalThreshold = 0.10 * viewBounds.height
        
        // move left, right, up, or down
        if(position.x < horizontalThreshold){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.frontCardCenterX {
                    constraint.constant = constraint.constant - viewBounds.width
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
            
        }else if(position.x > (view.bounds.width - horizontalThreshold)){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.frontCardCenterX {
                    constraint.constant = constraint.constant + viewBounds.width
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
            
        }else if(position.y < verticalThreshold){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.frontCardCenterY {
                    constraint.constant = constraint.constant - viewBounds.height
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
            
        }else if(position.y > (view.bounds.height - verticalThreshold)){
            UIView.animateWithDuration(0.3, delay: 0.05, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                if let constraint = self.frontCardCenterY {
                    constraint.constant = constraint.constant + viewBounds.height
                    self.view.layoutIfNeeded()
                }
                }) { (bool:Bool) -> Void in
                    cardView.removeFromSuperview()
                    self.setupNextCard()
            }
        }else{
            cardView.physics?.panGestureReset()
        }
*/
        cardView.physics?.panGestureReset()
    }
    
    func cardViewDragged(cardView: CardView, position: CGPoint) {
       // println(position)
       // println(frontCardCenter)
        //println(position)
        let xDiff = position.x - frontCardCenter.x
        let yDiff = position.y - frontCardCenter.y
        
        var distanceFromCenter:CGFloat = sqrt((xDiff * xDiff) + (yDiff * yDiff))
        //println(distanceFromCenter)
        
        let THRESHOLD:CGFloat = 200
        var percentage:CGFloat = 0
        if distanceFromCenter > THRESHOLD{
            percentage = 1
        }else{
            percentage = distanceFromCenter / THRESHOLD
        }
        
        println(percentage)
        
        let firstContainer = visibleCardConstraintContainers[0]
        
        let secondContainer = visibleCardConstraintContainers[1]
        secondContainer.width.constant = firstContainer.width.constant - 20 + (20*percentage)
        secondContainer.centerY.constant = firstContainer.centerY.constant - 10 + (10*percentage)
        view.layoutIfNeeded()
        
    }
    
    
    // MARK:Private
    /*
    func setupNextCard(){
        
        // back to front
        frontCard = backCard
        frontCardView = backCardView
        frontCardCenterX = backCardCenterX
        frontCardCenterY = backCardCenterY
        
        // up index
        currentCardIndex = nextIndex(currentCardIndex)
        
        // new back card
        let backCardIndex = nextIndex(currentCardIndex)
        let newBackCard = cards[backCardIndex]
        setupBackCard(newBackCard)
    }
*/
    
    
    // MARK:UIViewController
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapped")
        
        // Initialize Front Card
        let frontCard = cards[0]
        let firstCardView = CardView.createCardView(frontCard)
        view.addSubview(firstCardView!)
        let container = fullyConstrainCardView(firstCardView!)
        
        visibleCardViews.append(firstCardView!)
        visibleCardConstraintContainers.append(container)

        
         let secondCard = cards[1]
        let secondCardView = CardView.createCardView(secondCard)
        view.insertSubview(secondCardView!, belowSubview:firstCardView!)
        let container2 = fullyConstrainCardView(secondCardView!)
        
        container2.width.constant -= 20
        container2.centerY.constant -= 10
        
        visibleCardViews.append(secondCardView!)
        visibleCardConstraintContainers.append(container2)
        secondCardView?.setNeedsLayout()
        
        
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
    
    func nextIndex(index:Int)->Int{
        return (index + 1) % cards.count
    }
    
    /*
    func setupBackCard(card:Card){
        // set up the card in the back
        if(frontCardView != nil){
            backCard = card
            backCardView = CardView.createCardView(backCard!)
            backCardView?.delegate = self
            backCardView?.physics?.delegate = self
            backCardView?.physics?.enableDragging = true
            
            view.insertSubview(backCardView!, belowSubview: frontCardView!)
            backCardCenterX = backCardView?.horizontallyCenterToSuperView(0)
            backCardCenterY = backCardView?.verticallyCenterToSuperView(0)
            backCardView?.constrainWidth(backCardView!.frame.size.width, andHeight: backCardView!.frame.size.height)
        }
    }
*/
    
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