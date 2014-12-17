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
    
    func viewForCardBody()->UIView?
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
    // card view about to be reloaded, if you constrained the card view relative to
    // any of your custom views, this would be a good time to re-do if necessary.
    // at this point in the time the new CardView's frame has already been re calculated
    // but layout has not happened yet
    optional func cardViewWillReload(cardView:CardView)
    
    // card view has been reloaded with a new card
    optional func cardViewDidReload(cardView:CardView)
}

public class CardView : UIView
{
    // MARK: Public properties
    public var physics:CardPhysics?
    public var backingCard:Card!
    public var delegate:CardViewDelegate?
    
    // MARK: Private properties
    var containerView:UIView!
    var back:UIView?
    var header:UIView?
    var body:UIView?
    var footer:UIView?
    var datasource:CardViewDataSource?
    
    // MARK: Public Class Functions
    public class func autoCreateCardView(card:Card)->CardView?{
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(card)
        let datasource = CardViewDataSourceFactory.cardViewDataSourceFromLayout(layoutToUse, card: card)
        return CardView.createCardView(card, datasource: datasource)
    }
    
    public class func createCardView(card:Card, datasource:CardViewDataSource)->CardView?{
        let cardFrame = CardView.createFrameFromDataSource(datasource)
        let newCardView = CardView(frame: cardFrame)
        newCardView.datasource = datasource
        newCardView.layoutCardComponents()
        newCardView.backingCard = card
        newCardView.updateForCard(card)
        return newCardView
    }
    
    // MARK: Instance
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
        frame = CardView.createFrameFromDataSource(datasource)
        delegate?.cardViewWillReload?(self)
     
        // layout components
        layoutCardComponents()
        
        // backing card
        backingCard = card
        
        // update views
        updateForCard(backingCard)
        
        // reloaded
        delegate?.cardViewDidReload?(self)
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
        if let ds = datasource{
            let headerView = ds.viewForCardHeader?()
            if(headerView != nil && ds.heightForCardHeader?() > 0){
                headerView!.setTranslatesAutoresizingMaskIntoConstraints(false)
                containerView.addSubview(headerView!)
                containerView.addConstraint(NSLayoutConstraint(item: headerView!, attribute: NSLayoutAttribute.Width, relatedBy:NSLayoutRelation.Equal, toItem: headerView!.superview, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
                headerView!.horizontallyCenterToSuperView(0)
                containerView.addConstraint(NSLayoutConstraint(item: headerView!, attribute: NSLayoutAttribute.Top, relatedBy:NSLayoutRelation.Equal, toItem: headerView!.superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: currentHeightOffset))
                headerView!.constrainWidth(ds.widthForCard(), andHeight: ds.heightForCardHeader!())
                currentHeightOffset += ds.heightForCardHeader!()
                header = headerView
            }
            
            let bodyView = ds.viewForCardBody()
            if(bodyView != nil && ds.heightForCardBody() > 0){
                bodyView!.setTranslatesAutoresizingMaskIntoConstraints(false)
                containerView.addSubview(bodyView!)
                containerView.addConstraint(NSLayoutConstraint(item: bodyView!, attribute: NSLayoutAttribute.Width, relatedBy:NSLayoutRelation.Equal, toItem: bodyView!.superview, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
                bodyView!.horizontallyCenterToSuperView(0)
                containerView.addConstraint(NSLayoutConstraint(item: bodyView!, attribute: NSLayoutAttribute.Top, relatedBy:NSLayoutRelation.Equal, toItem: bodyView!.superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: currentHeightOffset))
                bodyView!.constrainWidth(ds.widthForCard(), andHeight: ds.heightForCardBody())
                currentHeightOffset += ds.heightForCardBody()
                body = bodyView
            }
            
            let footerView = ds.viewForCardFooter?()
            if(footerView != nil && ds.heightForCardFooter?() > 0){
                footerView!.setTranslatesAutoresizingMaskIntoConstraints(false)
                containerView.addSubview(footerView!)
                containerView.addConstraint(NSLayoutConstraint(item: footerView!, attribute: NSLayoutAttribute.Width, relatedBy:NSLayoutRelation.Equal, toItem: footerView!.superview, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
                footerView!.horizontallyCenterToSuperView(0)
                containerView.addConstraint(NSLayoutConstraint(item: footerView!, attribute: NSLayoutAttribute.Top, relatedBy:NSLayoutRelation.Equal, toItem: footerView!.superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: currentHeightOffset))
                footerView!.constrainWidth(ds.widthForCard(), andHeight: ds.heightForCardFooter!())
                currentHeightOffset += ds.heightForCardFooter!()
                footer = footerView
            }
            
            if let backView = ds.viewForBackOfCard?(){
                insertSubview(backView, belowSubview:containerView)
                backView.constrainToSuperViewEdges()
                backView.layer.cornerRadius = 2.0
                backView.layer.masksToBounds = true
                back = backView
            }
        }
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
    
    private class func createFrameFromDataSource(datasource:CardViewDataSource)->CGRect{
        let width = datasource.widthForCard()
        var height:CGFloat = 0
        if let headerHeight = datasource.heightForCardHeader?(){
            height += headerHeight
        }
        if let footerHeight = datasource.heightForCardFooter?(){
            height += footerHeight
        }
        height += datasource.heightForCardBody()
        return CGRectMake(0, 0, width, height)
    }

    private func convenienceInitialize(){
        
        // remove container view and back view
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