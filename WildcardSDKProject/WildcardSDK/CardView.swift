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
public protocol CardViewDataSource{
    
    func viewForCardBody()->UIView
    func heightForCardBody()->CGFloat
    func widthForCard()->CGFloat
    
    optional func viewForCardHeader()->UIView?
    optional func heightForCardHeader()->CGFloat
    optional func viewForCardFooter()->UIView?
    optional func heightForCardFooter()->CGFloat
    optional func viewForBackOfCard()->UIView?
}

@objc
public protocol CardViewDelegate{
    
    /*
    CardView about to be reloaded.
   
    Based on any new dataSource for the card, internal constraints of the CardView may change.
    If you constrained the CardView relative to any of your custom views, this is the time
    to re-do any layout if necessary. At this point in the time the new CardView's frame
    has already been re-calculated, but layout has not happened yet.
    */
    optional func cardViewWillReload(cardView:CardView)

    optional func cardViewDidReload(cardView:CardView)
    
    optional func cardViewRequestedMaximize(cardView:CardView)
    
    optional func cardViewRequestedCollapse(cardView:CardView)
    
    optional func cardViewRequestViewOnWeb(cardView:CardView)
    
}

public class CardView : UIView, CardViewElementDelegate
{
    // MARK: Public properties
    public var physics:CardPhysics?
    public var delegate:CardViewDelegate?
    public var backingCard:Card!
    public var backingDataSource:CardViewDataSource{
        get{
            return self.datasource
        }
    }
    
    // MARK: Public Class Functions
    public class func createCardView(card:Card)->CardView?{
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(card)
        let datasource = CardViewDataSourceFactory.cardViewDataSourceFromLayout(layoutToUse, card: card)
        return CardView.createCardView(card, datasource: datasource)
    }
    
    public class func createCardView(card:Card, datasource:CardViewDataSource)->CardView?{
        let size = CardView.createSizeFromDataSource(datasource)
        let cardFrame = CGRectMake(0, 0, size.width, size.height)
        let newCardView = CardView(frame: cardFrame)
        newCardView.datasource = datasource
        newCardView.layoutCardComponents()
        newCardView.backingCard = card
        newCardView.refresh()
        return newCardView
    }
    
    
    // MARK: Public Instance
    public func refresh(){
        updateForCard(backingCard)
    }
    
    public func reloadWithCard(newCard:Card){
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(newCard)
        let autoDatasource = CardViewDataSourceFactory.cardViewDataSourceFromLayout(layoutToUse, card: newCard)
        reloadWithCard(newCard, datasource: autoDatasource)
    }
    
    public func reloadWithCard(card:Card, datasource:CardViewDataSource){
        
        // initialize again
        convenienceInitialize()
        self.datasource = datasource
        
        // calculate new frame, let delegate prepare
        let newSize = CardView.createSizeFromDataSource(datasource)
        frame = CGRectMake(frame.origin.x, frame.origin.y, newSize.width, newSize.height)
        delegate?.cardViewWillReload?(self)
        
        // layout components
        layoutCardComponents()
        
        // backing card
        backingCard = card
        
        // update views
        refresh()
        
        // reloaded
        delegate?.cardViewDidReload?(self)
    }
    
    // MARK: Private properties
    var containerView:UIView!
    var back:UIView?
    var header:UIView?
    var body:UIView?
    var footer:UIView?
    var datasource:CardViewDataSource!
    
    // MARK: CardViewElementDelegate
    func cardViewElementRequestedReadMore() {
        delegate?.cardViewRequestedMaximize?(self)
    }
    
    func cardViewElementRequestedToClose() {
        delegate?.cardViewRequestedCollapse?(self)
    }
    
    func cardViewElementRequestedViewOnWeb() {
        delegate?.cardViewRequestViewOnWeb?(self)
    }
    
    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        convenienceInitialize()
    }
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        
        // reset shadow path
        let path = UIBezierPath(rect: bounds)
        layer.shadowPath =  path.CGPath
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        convenienceInitialize()
    }
    
    // MARK: Private
    private func layoutCardComponents(){
        
        // initialize header, body, footer of card
        var currentHeightOffset:CGFloat = 0
        let headerView = datasource.viewForCardHeader?()
        if(headerView != nil && datasource.heightForCardHeader?() > 0){
            constrainSubComponent(headerView!, offset: currentHeightOffset, height: datasource.heightForCardHeader!())
            currentHeightOffset += datasource.heightForCardHeader!()
            header = headerView
            if let cardElement = header as? CardViewElement{
                cardElement.delegate = self
            }
        }
        
        let bodyView = datasource.viewForCardBody()
        if(datasource.heightForCardBody() > 0){
            constrainSubComponent(bodyView, offset: currentHeightOffset, height: datasource.heightForCardBody())
            currentHeightOffset += datasource.heightForCardBody()
            body = bodyView
            if let cardElement = body as? CardViewElement{
                cardElement.delegate = self
            }
        }else{
            println("Card layout error: height for card body should not be 0")
        }
        
        let footerView = datasource.viewForCardFooter?()
        if(footerView != nil && datasource.heightForCardFooter?() > 0){
            constrainSubComponent(footerView!, offset: currentHeightOffset, height: datasource.heightForCardFooter!())
            currentHeightOffset += datasource.heightForCardFooter!()
            footer = footerView
            if let cardElement = footer as? CardViewElement{
                cardElement.delegate = self
            }
        }
        
        if let backView = datasource.viewForBackOfCard?(){
            insertSubview(backView, belowSubview:containerView)
            backView.constrainToSuperViewEdges()
            backView.layer.cornerRadius = 2.0
            backView.layer.masksToBounds = true
            back = backView
            if let cardViewElement = back as? CardViewElement{
                cardViewElement.delegate = self
            }
        }
    }
    
    private func constrainSubComponent(cardComponent:UIView, offset:CGFloat, height:CGFloat){
        containerView.addSubview(cardComponent)
        cardComponent.horizontallyCenterToSuperView(0)
        containerView.addConstraint(NSLayoutConstraint(item: cardComponent, attribute: NSLayoutAttribute.Top, relatedBy:NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: offset))
        cardComponent.constrainWidth(datasource.widthForCard(), andHeight: height)
    }
    
    private func updateForCard(card:Card){
        if let header = header as? CardViewElement{
            header.updateForCard(card)
        }
        if let body = body as? CardViewElement{
            body.updateForCard(card)
        }
        if let footer = footer as? CardViewElement{
            footer.updateForCard(card)
        }
    }
    
    private class func createSizeFromDataSource(datasource:CardViewDataSource)->CGSize{
        let width = datasource.widthForCard()
        var height:CGFloat = 0
        if let headerHeight = datasource.heightForCardHeader?(){
            height += headerHeight
        }
        if let footerHeight = datasource.heightForCardFooter?(){
            height += footerHeight
        }
        height += datasource.heightForCardBody()
        return CGSizeMake(width, height)
    }

    private func convenienceInitialize(){
        
        // remove container and back view
        containerView?.removeFromSuperview()
        containerView = nil
        back?.removeFromSuperview()
        back = nil
        
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
}