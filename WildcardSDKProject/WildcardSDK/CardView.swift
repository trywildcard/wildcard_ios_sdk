//
//  CardView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation
import UIKit
import QuartzCore

@objc
public protocol CardViewVisualSource{
    
    func viewForCardBody()->CardViewElement
    func heightForCardBody()->CGFloat
    
    func widthForCard()->CGFloat
    
    optional func viewForCardHeader()->CardViewElement?
    optional func heightForCardHeader()->CGFloat
    optional func viewForCardFooter()->CardViewElement?
    optional func heightForCardFooter()->CGFloat
    optional func viewForBackOfCard()->CardViewElement?
}

/**
The visual source of a maximized CardView extends from the standard visual source.

The maximized visual source should always be used with the extension UIView.maximizeCardView. This visual source is responsible for displaying a Card during its 'maximized state'. In this state, the Card takes up the entire application frame, and is owned by a fully presented view controller.

This visual source may never be used for an inline card. 
*/
@objc
public protocol MaximizedCardViewVisualSource : CardViewVisualSource {
    
    /**
    This represents the edge insets of the maximized CardView to the application frame.
    
    This must be defined carefully with the width / height protocol functions since both will dictate the eventual size of the card.
    */
    func applicationFrameEdgeInsets()->UIEdgeInsets
}

@objc
public protocol CardViewDelegate{
    
    /**
    The CardView is about to go through re-layout. For example, if a CardView is reloaded
    with a brand new Card and visual source, a re-layout of the CardView will happen. This lets
    the delegate prepare for the re-layout given the old and new-size for any elements dependent
    on the CardView
    
    :param: fromSize - The previous size of the CardView
    :param: toSize - The new size of the CardView
    */
    optional func cardViewWillLayoutToNewSize(cardView:CardView, fromSize:CGSize, toSize:CGSize)
    
    /**
    Simply just a hook into UIView.layoutSubviews()
    */
    optional func cardViewLayoutSubviews(cardView:CardView)
    
    /**
    CardView is about to be reloaded.
    */
    optional func cardViewWillReload(cardView:CardView)

    /**
    CardView has reloaded.
    */
    optional func cardViewDidReload(cardView:CardView)
    
    /**
    CardView has been requested to perform a specific action
    */
    optional func cardViewRequestedAction(cardView:CardView, action: CardViewAction) 
    
    /**
    The CardView has been explicitly requested to open a URL. By default, Cards
    will just call the standard UIApplication.openURL if this function is not implemented or
    returns true. To do something custom, you may implement this function to do something custom
    and return false.
    
    :param: url - The URL to be opened
    */
    optional func cardViewShouldRedirectToURL(cardView:CardView, url:NSURL) -> Bool
    
}

@objc
public class CardView : UIView
{
    // MARK: Public properties
    public var physics:CardPhysics?
    public var delegate:CardViewDelegate?
    public var visualSource:CardViewVisualSource!
    public var backingCard:Card!
    
    // MARK: Public Class Functions
    public class func createCardView(card:Card)->CardView?{
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(card)
        return CardView.createCardView(card, template: layoutToUse)
    }
    
    public class func createCardView(card:Card, template:WCTemplate)->CardView?{
        let datasource = CardViewVisualSourceFactory.visualSourceFromLayout(template, card: card)
        return CardView.createCardView(card, visualSource: datasource)
    }
    
    public class func createCardView(card:Card, visualSource:CardViewVisualSource)->CardView?{
        let newCardView = CardView(frame: CGRectZero)
        
        // init data and visuals
        newCardView.backingCard = card
        newCardView.visualSource = visualSource
        
        // layout card elements
        newCardView.layoutCardComponents()
        
        // layout the card view before returning
        let size = Utilities.sizeFromVisualSource(visualSource)
        newCardView.frame = CGRectMake(0, 0, size.width, size.height)
        newCardView.layoutIfNeeded()
        
        newCardView.notifyCardViewElementsFinishedLayout()
        
        return newCardView
    }
    
    // MARK: Public Instance
    public func refresh(){
        var cardViews:[CardViewElement?] = [header, body, footer, back]
        for view in cardViews{
            view?.update()
        }
    }
    
    public func reloadWithCard(newCard:Card){
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(newCard)
        let autoDatasource = CardViewVisualSourceFactory.visualSourceFromLayout(layoutToUse, card: newCard)
        reloadWithCard(newCard, visualSource: autoDatasource)
    }
    
    public func reloadWithCard(card:Card, visualSource:CardViewVisualSource){
        
        backingCard = card
        self.visualSource = visualSource
        
        delegate?.cardViewWillReload?(self)
        
        // remove old card subviews
        removeCardSubviews()
        
        // layout components
        layoutCardComponents()
        
        // calculate new card frame, let delegate prepare
        let newSize = Utilities.sizeFromVisualSource(visualSource)
        delegate?.cardViewWillLayoutToNewSize?(self, fromSize: bounds.size, toSize: newSize)
        frame = CGRectMake(frame.origin.x, frame.origin.y, newSize.width, newSize.height)
        layoutIfNeeded()
        
        notifyCardViewElementsFinishedLayout()
        
        // reloaded
        delegate?.cardViewDidReload?(self)
    }
    
    public func fadeOut(duration:NSTimeInterval, delay:NSTimeInterval, completion:((bool:Bool) -> Void)?){
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.header?.alpha = 0
            self.body?.alpha = 0
            self.footer?.alpha = 0
            self.back?.alpha = 0
            }) { (bool:Bool) -> Void in
                completion?(bool: bool)
                return
        }
    }
    
    public func fadeIn(duration:NSTimeInterval, delay:NSTimeInterval, completion:((bool:Bool) -> Void)?){
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.header?.alpha = 1
            self.body?.alpha = 1
            self.footer?.alpha = 1
            self.back?.alpha = 1
            }) { (bool:Bool) -> Void in
                completion?(bool: bool)
                return
        }
    }
    
    // MARK: Private properties
    var containerView:UIView!
    var back:CardViewElement?
    var header:CardViewElement?
    var body:CardViewElement!
    var footer:CardViewElement?
    
    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        convenienceInitialize()
    }
    
    override public func layoutSubviews(){
        super.layoutSubviews()
        
        delegate?.cardViewLayoutSubviews?(self)
        
        // reset shadow path to whatever bounds card is taking up
        let path = UIBezierPath(rect: bounds)
        layer.shadowPath = path.CGPath
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        convenienceInitialize()
    }
    
    // MARK: Private
    public func notifyCardViewElementsFinishedLayout(){
        var cardViews:[CardViewElement?] = [header, body, footer, back]
        for view in cardViews{
            view?.cardViewFinishedLayout()
        }
    }
    
    private func layoutCardComponents(){
        
        // initialize header, body, footer of card
        var currentHeightOffset:CGFloat = 0
        if let headerView = visualSource.viewForCardHeader?(){
            headerView.cardView = self
            headerView.update()
            if(visualSource.heightForCardHeader?() > 0){
                constrainSubComponent(headerView, offset: currentHeightOffset, height: visualSource.heightForCardHeader!())
                currentHeightOffset += visualSource.heightForCardHeader!()
                header = headerView
            }
        }
        
        let bodyView = visualSource.viewForCardBody()
        bodyView.cardView = self
        bodyView.update()
        if(visualSource.heightForCardBody() > 0){
            constrainSubComponent(bodyView, offset: currentHeightOffset, height: visualSource.heightForCardBody())
            currentHeightOffset += visualSource.heightForCardBody()
            body = bodyView
        }else{
            println("Card layout error: height for card body should not be 0")
        }
        
        if let footerView = visualSource.viewForCardFooter?(){
            footerView.cardView = self
            footerView.update()
            if(visualSource.heightForCardFooter?() > 0){
                constrainSubComponent(footerView, offset: currentHeightOffset, height: visualSource.heightForCardFooter!())
                currentHeightOffset += visualSource.heightForCardFooter!()
                footer = footerView
            }
        }
        
        if let backView = visualSource.viewForBackOfCard?(){
            backView.cardView = self
            backView.update()
            insertSubview(backView, belowSubview:containerView)
            backView.constrainToSuperViewEdges()
            backView.layer.cornerRadius = 2.0
            backView.layer.masksToBounds = true
            back = backView
        }
    }
    
    private func constrainSubComponent(cardComponent:UIView, offset:CGFloat, height:CGFloat){
        containerView.addSubview(cardComponent)
        cardComponent.constrainLeftToSuperView(0)
        cardComponent.constrainRightToSuperView(0)
        cardComponent.constrainTopToSuperView(offset)
        cardComponent.constrainHeight(height)
    }
    
    private func convenienceInitialize(){
        
        backgroundColor = UIColor.clearColor()
        
        // always have a white container view holder card elements
        containerView = UIView(frame: CGRectZero)
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.layer.cornerRadius = 2.0
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        containerView.constrainToSuperViewEdges()
        
        // drop shadow goes on actual card layer
        layer.shadowColor = UIColor.wildcardMediumGray().CGColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSizeMake(0.0, 1.0)
        layer.shadowRadius = 1.0
        
        physics = CardPhysics(cardView:self)
        physics?.setup()
    }
    
    private func removeCardSubviews(){
        var cardViews:[UIView?] = [header, body, footer, back]
        for view in cardViews{
            view?.removeFromSuperview()
        }
    }
}