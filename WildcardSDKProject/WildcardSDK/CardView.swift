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

Every CardView is associated with a visual source to provide layout guidelines as well as views for various subcomponents. If you choose to completely customize a card, you will have to implement a visual source of your own. 

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
    
    /// ALPHA: Optional CardViewElement for the back of the card. Spans the full card, shown on double tap
    optional func viewForBackOfCard()->CardViewElement?
}

/**
ALPHA: The visual source of a maximized CardView

The maximized visual source should always be used with the extension UIView.maximizeCardView. This visual source is responsible for displaying a Card during its 'maximized state'. In this state, the Card takes up the entire application frame, and is owned by a fully presented view controller.

This visual source may never be used for an inline card. widthForCard() is a no-op for a maximized card visual source as the size is always determined relative to the application frame with applicationFrameEdgeInsets
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
    Optionally gates the CardView action, always called before an action is requested.
    
    If this function is not implemented the action will be requested.
    */
    optional func cardViewShouldPerformAction(cardView:CardView, action: CardViewAction) -> Bool
    
    /**
    CardView has been requested to perform a specific action.
    */
    optional func cardViewRequestedAction(cardView:CardView, action: CardViewAction)
    
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
    
    /// ALPHA: See CardPhysics
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
    public class func createCardView(card:Card)->CardView?{
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(card)
        return CardView.createCardView(card, layout: layoutToUse, preferredWidth:UIViewNoIntrinsicMetric)
    }
    
    /// Creates a CardView from a card with a prechosen layout. The CardView will be returned with a default size.
    public class func createCardView(card:Card, layout:WCCardLayout)->CardView?{
        if(!card.supportsLayout(layout)){
            println("Unsupported layout for this card type, returning nil.")
            return nil
        }
        let datasource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card)
        return CardView.createCardView(card, visualSource: datasource, preferredWidth:UIViewNoIntrinsicMetric)
    }

    /**
    Creates a CardView from a card with a prechosen layout and width. 
    
    The card's size will be calculated optimally from the preferredWidth. You may choose various layouts and widths to a get a height that is suitable.
    */
    public class func createCardView(card:Card, layout:WCCardLayout, preferredWidth:CGFloat)->CardView?{
        if(!card.supportsLayout(layout)){
            println("Unsupported layout for this card type, returning nil.")
            return nil
        }
        let datasource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card)
        return CardView.createCardView(card, visualSource: datasource, preferredWidth:preferredWidth)
    }
    
    /**
    Creates a CardView with a customized visual source. See tutorials on how to create your own visual source.
    
    Passing in UIViewNoIntrinsicMetric for the width will result in a default width calculation based on screen size
    */
    public class func createCardView(card:Card, visualSource:CardViewVisualSource, preferredWidth:CGFloat)->CardView?{
        
        if(WildcardSDK.apiKey == nil){
            println("Wildcard API Key not initialized -- can't create CardView.")
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
    public func reloadWithCard(newCard:Card){
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(newCard)
        return reloadWithCard(newCard, layout: layoutToUse)
    }
    
    /// ALPHA: Reloads the CardView with a new card and specified layout.
    public func reloadWithCard(newCard:Card, layout:WCCardLayout){
        if(!newCard.supportsLayout(layout)){
            println("Unsupported layout for this card type, nothing reloaded.")
            return
        }
        let autoDatasource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: newCard)
        reloadWithCard(newCard, visualSource: autoDatasource, preferredWidth:UIViewNoIntrinsicMetric)
    }
    
    /// ALPHA: Reloads the CardView with a new card, specified layout, and preferredWidth.
    public func reloadWithCard(newCard:Card, layout:WCCardLayout, preferredWidth:CGFloat){
        if(!newCard.supportsLayout(layout)){
            println("Unsupported layout for this card type, nothing reloaded.")
            return
        }
        let autoDatasource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: newCard)
        reloadWithCard(newCard, visualSource: autoDatasource, preferredWidth:preferredWidth)
    }
    
    /// ALPHA: Reloads the CardView with a new card, custom visual source, and preferredWidth
    public func reloadWithCard(card:Card, visualSource:CardViewVisualSource, preferredWidth:CGFloat){
        
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
    
    required public init(coder: NSCoder) {
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
                var params:NSDictionary = ["url":shareUrl]
                let cardAction = CardViewAction(type: WCCardAction.Share, parameters: params)
                let shouldPerform = self.delegate?.cardViewShouldPerformAction?(self, action: cardAction)
                if(shouldPerform == true || shouldPerform == nil){
                    self.delegate?.cardViewRequestedAction?(self, action: cardAction)
                }
            }
        })
    }
    
    func handleViewOnWeb(url:NSURL){
        let params:NSDictionary = ["url":url]
        let cardAction = CardViewAction(type: WCCardAction.ViewOnWeb, parameters: params)
        let shouldPerform = delegate?.cardViewShouldPerformAction?(self, action: cardAction)
        if(shouldPerform == true || shouldPerform == nil){
            delegate?.cardViewRequestedAction?(self, action: cardAction)
        }
    }
    
    func handleDownloadApp(){
        if let articleCard = backingCard as? ArticleCard{
            if let url = articleCard.creator.iosAppStoreUrl {
                var lastComponent:NSString = url.lastPathComponent!
                var id = lastComponent.substringFromIndex(2) as NSString
                var params:NSDictionary = ["id":id]
                
                let cardAction = CardViewAction(type: WCCardAction.DownloadApp, parameters: params)
                let shouldPerform = delegate?.cardViewShouldPerformAction?(self, action: cardAction)
                if(shouldPerform == true || shouldPerform == nil){
                    delegate?.cardViewRequestedAction?(self, action: cardAction)
                }
            }
        }
    }
    
    class func defaultWidth()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        if(screenBounds.width > screenBounds.height){
            return screenBounds.height - (2 * WildcardSDK.defaultScreenMargin)
        }else{
            return screenBounds.width - (2 * WildcardSDK.defaultScreenMargin)
        }
        
    }
    
    // MARK: Private
    
    private func initializeCardComponents(){
        header = visualSource.viewForCardHeader?()
        header?.preferredWidth = preferredWidth
        body = visualSource.viewForCardBody()
        body.preferredWidth = preferredWidth
        footer = visualSource.viewForCardFooter?()
        footer?.preferredWidth = preferredWidth
        
        // initialize and update
        body.cardView = self
        body.update(backingCard)
        header?.cardView = self
        header?.update(backingCard)
        footer?.cardView = self
        footer?.update(backingCard)
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
        
        println("intrinsic size for card view")
        println(size)
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
        
        // card body layout has 4 height layout possibilities
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
        
        // Back of the card always constrain to edges if it exists
        if let backView = visualSource.viewForBackOfCard?(){
            backView.cardView = self
            backView.update(backingCard)
            insertSubview(backView, belowSubview:containerView)
            backView.constrainToSuperViewEdges()
            backView.layer.cornerRadius = WildcardSDK.cardCornerRadius
            backView.layer.masksToBounds = true
            back = backView
        }
        
    }
    
    private func convenienceInitialize(){
        
        backgroundColor = UIColor.clearColor()
        
        // always have a white container view holder card elements
        containerView = UIView(frame: CGRectZero)
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.layer.cornerRadius = WildcardSDK.cardCornerRadius
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