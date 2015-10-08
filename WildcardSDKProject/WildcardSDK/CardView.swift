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

/**
The visual source of a CardView.

Every CardView is associated with a visual source and provides views for various subcomponents. If you choose to completely customize a card, you will have to implement a visual source of your own.

Each subcomponent of a CardView must extend CardViewElement.
*/
@objc
public protocol CardViewVisualSource{
    
    /// CardViewElement for the card body
    func viewForCardBody()->CardViewElement
    
    /// Optional CardViewElement for header
    optional func viewForCardHeader()->CardViewElement?
    
    /// Optional CardViewElement for footer
    optional func viewForCardFooter()->CardViewElement?
    
    /// Optional CardViewElement for the back of the card. Spans the full card, shown on double tap
    optional func viewForBackOfCard()->CardViewElement?
}

/**
ALPHA: The visual source of a maximized CardView

The maximized visual source should always be used with the extension UIView.maximizeCardView. This visual source is responsible for displaying a Card during its 'maximized state'. In this state, the Card takes up the entire application frame, and is owned by a fully presented view controller.

This visual source may never be used for an inline card. The size is always determined relative to the application frame using applicationFrameEdgeInsets
*/
@objc
public protocol MaximizedCardViewVisualSource : CardViewVisualSource {
    
    /**
    This represents the edge insets of the maximized CardView to the application frame.
    
    This is essentially how inset the CardView is from the screen
    */
    func applicationFrameEdgeInsets()->UIEdgeInsets
}

@objc
public protocol CardViewDelegate{
    
    /**
    Simply just a hook into UIView.layoutSubviews() for the CardView
    */
    optional func cardViewLayoutSubviews(cardView:CardView)
    
    /**
    CardView has been requested to perform a specific action.
    */
    optional func cardViewRequestedAction(cardView:CardView, action:CardViewAction)
    
    /**
    CardView is about to be reloaded.
    */
    optional func cardViewWillReload(cardView:CardView)
    
    /**
    CardView has reloaded.
    */
    optional func cardViewDidReload(cardView:CardView)
    
}

@objc
public class CardView : UIView
{
    // MARK: Public
    
    /// See CardPhysics
    public var physics:CardPhysics?
    
    /// See CardViewDelegate
    public var delegate:CardViewDelegate?
    
    /// The visual source associated with this CardView
    public var visualSource:CardViewVisualSource!
    
    /// The backing card for this CardView
    public var backingCard:Card!
    
    /**
    Preferred width for the CardView. When a CardView lays out its subcomponents from a visual source, each subcomponent will also be assigned this preferred width.
    
    Changing the preferredWidth for the CardView will affect the intrinsic size of the subcomponents and the CardView itself.
    */
    public var preferredWidth:CGFloat{
        get{
            return __preferredWidth
        }set{
            __preferredWidth = newValue
            for element in [header, body, footer, back]{
                element?.preferredWidth = __preferredWidth
            }
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Creates a CardView from a card. A layout will be chosen and the CardView will be returned with a default size.
    public class func createCardView(card:Card!)->CardView?{
        if let card = card {
            let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(card)
            return CardView.createCardView(card, layout: layoutToUse, preferredWidth:UIViewNoIntrinsicMetric)
        }else{
            print("Can't create CardView from nil card")
            return nil
        }
    }
    
    /// Creates a CardView from a card with a prechosen layout. The CardView will be returned with a default size.
    public class func createCardView(card:Card!, layout:WCCardLayout)->CardView?{
        if let card = card {
            if(!card.supportsLayout(layout)){
                print("Unsupported layout for this card type, returning nil.")
                return nil
            }
            let datasource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card)
            return CardView.createCardView(card, visualSource: datasource, preferredWidth:UIViewNoIntrinsicMetric)
        }else{
            print("Can't create CardView from nil card")
            return nil
        }
    }

    /**
    Creates a CardView from a card with a prechosen layout and width. 
    
    The card's size will be calculated optimally from the preferredWidth. You may choose various layouts and widths to a get a height that is suitable.
    */
    public class func createCardView(card:Card!, layout:WCCardLayout, preferredWidth:CGFloat)->CardView?{
        if let card = card {
            if(!card.supportsLayout(layout)){
                print("Unsupported layout for this card type, returning nil.")
                return nil
            }
            let datasource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card)
            return CardView.createCardView(card, visualSource: datasource, preferredWidth:preferredWidth)
        }else{
            print("Can't create CardView from nil card")
            return nil
        }
    }
    
    /**
    Creates a CardView with a customized visual source. See tutorials on how to create your own visual source.
    
    Passing in UIViewNoIntrinsicMetric for the width will result in a default width calculation based on screen size
    */
    public class func createCardView(card:Card!, visualSource:CardViewVisualSource!, preferredWidth:CGFloat)->CardView?{
        
        if(card == nil){
            print("Card is nil -- can't create CardView.")
            return nil
        }else if(visualSource == nil){
            print("Visual source is nil -- can't create CardView.")
            return nil
        }else if(WildcardSDK.apiKey == nil){
            print("Wildcard API Key not initialized -- can't create CardView.")
            return nil
        }
        
        WildcardSDK.analytics?.trackEvent("CardViewCreated", withProperties: nil, withCard: card)
        
        let newCardView = CardView(frame: CGRectZero)
        
        // default width if necessary
        if(preferredWidth == UIViewNoIntrinsicMetric){
            newCardView.preferredWidth = CardView.defaultWidth()
        }else{
            newCardView.preferredWidth = preferredWidth
        }
        
        // init data and visuals
        newCardView.backingCard = card
        newCardView.visualSource = visualSource
        newCardView.initializeCardComponents()
        
        // set frame to default at intrinsic size
        let size = newCardView.intrinsicContentSize()
        newCardView.frame = CGRectMake(0, 0, size.width, size.height)
        
        // lays out card components
        newCardView.layoutCardComponents()
        
        return newCardView
    }
    
    /// ALPHA: Reloads the CardView with a new card. Autogenerates a layout
    public func reloadWithCard(newCard:Card!){
        if let card = newCard {
            let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(card)
            return reloadWithCard(card, layout: layoutToUse)
        }else{
            print("Can't reload with nil card")
        }
    }
    
    /// ALPHA: Reloads the CardView with a new card and specified layout.
    public func reloadWithCard(newCard:Card!, layout:WCCardLayout){
        if let card = newCard {
            if(!card.supportsLayout(layout)){
                print("Unsupported layout for this card type, nothing reloaded.")
                return
            }
            let autoDatasource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card)
            reloadWithCard(card, visualSource: autoDatasource, preferredWidth:UIViewNoIntrinsicMetric)
        }else{
            print("Can't reload with nil card")
        }
    }
    
    /// ALPHA: Reloads the CardView with a new card, specified layout, and preferredWidth.
    public func reloadWithCard(newCard:Card!, layout:WCCardLayout, preferredWidth:CGFloat){
        if let card = newCard {
            if(!card.supportsLayout(layout)){
                print("Unsupported layout for this card type, nothing reloaded.")
                return
            }
            let autoDatasource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card)
            reloadWithCard(card, visualSource: autoDatasource, preferredWidth:preferredWidth)
        }else{
            print("Can't reload with nil card")
        }
    }
    
    /// ALPHA: Reloads the CardView with a new card, custom visual source, and preferredWidth
    public func reloadWithCard(newCard:Card!, visualSource:CardViewVisualSource, preferredWidth:CGFloat){
        if let card = newCard {
            delegate?.cardViewWillReload?(self)
            
            // default width if necessary
            if(preferredWidth == UIViewNoIntrinsicMetric){
                self.preferredWidth = CardView.defaultWidth()
            }else{
                self.preferredWidth = preferredWidth
            }
            
            backingCard = card
            self.visualSource = visualSource
            
            // remove old card subviews
            removeCardSubviews()
            
            initializeCardComponents()
            
            layoutCardComponents()
            
            invalidateIntrinsicContentSize()
            
            // reloaded
            delegate?.cardViewDidReload?(self)
        }else{
            print("Can't reload with nil card")
        }
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
    private var __preferredWidth:CGFloat = UIViewNoIntrinsicMetric
    
    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        convenienceInitialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        convenienceInitialize()
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if(hasSuperview()){
            WildcardSDK.analytics?.trackEvent("CardViewDisplayed", withProperties: nil, withCard: backingCard)
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        convenienceInitialize()
    }
    
    override public func layoutSubviews(){
        super.layoutSubviews()
        
        delegate?.cardViewLayoutSubviews?(self)
        
        // reset shadow path to whatever bounds card is taking up
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: WildcardSDK.cardCornerRadius)
        layer.shadowPath = path.CGPath
    }
    
    // MARK: Instance
    func handleShare(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Platform.sharedInstance.createWildcardShortLink(backingCard.webUrl, completion: { (url:NSURL?, error:NSError?) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let shareUrl = url {
                let params:NSDictionary = ["url":shareUrl]
                let cardAction = CardViewAction(type: WCCardAction.Share, parameters: params)
                self.delegate?.cardViewRequestedAction?(self, action: cardAction)
            }
        })
    }
    
    func handleViewOnWeb(url:NSURL){
        let params:NSDictionary = ["url":url]
        let cardAction = CardViewAction(type: WCCardAction.ViewOnWeb, parameters: params)
        delegate?.cardViewRequestedAction?(self, action: cardAction)
    }
    
    func handleDownloadApp(){
        if let articleCard = backingCard as? ArticleCard{
            if let url = articleCard.creator.iosAppStoreUrl {
                let lastComponent:NSString = url.lastPathComponent!
                let id = lastComponent.substringFromIndex(2) as NSString
                let params:NSDictionary = ["id":id]
                
                let cardAction = CardViewAction(type: WCCardAction.DownloadApp, parameters: params)
                delegate?.cardViewRequestedAction?(self, action: cardAction)
            }
        }
    }
    
    // MARK: Private
    
    private class func defaultWidth()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        if(screenBounds.width > screenBounds.height){
            return screenBounds.height - (2 * WildcardSDK.defaultScreenMargin)
        }else{
            return screenBounds.width - (2 * WildcardSDK.defaultScreenMargin)
        }
        
    }
    
    private func initializeCardComponents(){
        header = visualSource.viewForCardHeader?()
        header?.preferredWidth = preferredWidth
        body = visualSource.viewForCardBody()
        body.preferredWidth = preferredWidth
        footer = visualSource.viewForCardFooter?()
        footer?.preferredWidth = preferredWidth
        
        back = visualSource.viewForBackOfCard?()
        back?.preferredWidth = preferredWidth
        back?.layer.cornerRadius = WildcardSDK.cardCornerRadius
        back?.layer.masksToBounds = true
        
        // initialize and update
        let cardViews:[CardViewElement?] = [header, body, footer, back]
        for view in cardViews{
            view?.cardView = self
            view?.update(backingCard)
        }
    }
    
    override public func intrinsicContentSize() -> CGSize {
        var height:CGFloat = 0
        
        if(header != nil){
            height += header!.optimizedHeight(preferredWidth)
        }
        
        height += body.optimizedHeight(preferredWidth)
        
        if(footer != nil){
            height += footer!.optimizedHeight(preferredWidth)
        }
        
        let size = CGSizeMake(preferredWidth, height)
        return size
    }
    
    private func layoutCardComponents(){
        // header and footer always stick to top and bottom
        if(header != nil){
            containerView.addSubview(header!)
            header!.constrainLeftToSuperView(0)
            header!.constrainRightToSuperView(0)
            header!.constrainTopToSuperView(0)
        }
        
        if(footer != nil){
            containerView.addSubview(footer!)
            footer!.constrainLeftToSuperView(0)
            footer!.constrainRightToSuperView(0)
            footer!.constrainBottomToSuperView(0)
        }
        
        containerView.addSubview(body)
        body.constrainLeftToSuperView(0)
        body.constrainRightToSuperView(0)
        
        // card body layout has 4 vertical layout possibilities
        if(header == nil && footer == nil){
            containerView.addConstraint(NSLayoutConstraint(item: body, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1.0, constant: 0))
            containerView.addConstraint(NSLayoutConstraint(item: body, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0))
        }else if(header != nil && footer == nil){
            containerView.addConstraint(NSLayoutConstraint(item: body, attribute: .Top, relatedBy: .Equal, toItem: header!, attribute: .Bottom, multiplier: 1.0, constant: 0))
            containerView.addConstraint(NSLayoutConstraint(item: body, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0))
        }else if(header == nil && footer != nil){
            containerView.addConstraint(NSLayoutConstraint(item: body, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1.0, constant: 0))
            containerView.addConstraint(NSLayoutConstraint(item: body, attribute: .Bottom, relatedBy: .Equal, toItem: footer!, attribute: .Top, multiplier: 1.0, constant: 0))
        }else{
            containerView.addConstraint(NSLayoutConstraint(item: body, attribute: .Top, relatedBy: .Equal, toItem: header!, attribute: .Bottom, multiplier: 1.0, constant: 0))
            containerView.addConstraint(NSLayoutConstraint(item: body, attribute: .Bottom, relatedBy: .Equal, toItem: footer!, attribute: .Top, multiplier: 1.0, constant: 0))
        }
    }
    
    private func convenienceInitialize(){
        
        backgroundColor = UIColor.clearColor()
        
        // container view holds card view elements
        containerView = UIView(frame: CGRectZero)
        containerView.backgroundColor = WildcardSDK.cardBackgroundColor
        containerView.layer.cornerRadius = WildcardSDK.cardCornerRadius
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        containerView.constrainToSuperViewEdges()
        
        // drop shadow if enabled
        if(WildcardSDK.cardDropShadow){
            layer.shadowColor = UIColor.wildcardMediumGray().CGColor
            layer.shadowOpacity = 0.8
            layer.shadowOffset = CGSizeMake(0.0, 1.0)
            layer.shadowRadius = 1.0
        }
        
        physics = CardPhysics(cardView:self)
        physics?.setup()
    }
    
    private func removeCardSubviews(){
        let cardViews:[UIView?] = [header, body, footer, back]
        for view in cardViews{
            view?.removeFromSuperview()
        }
    }
}