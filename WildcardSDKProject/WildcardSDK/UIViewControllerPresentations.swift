//
//  UIViewControllerPresentations.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation
import StoreKit

public extension UIViewController{
    
    /// Presents a Card with a best-fit layout
    public func presentCard(card:Card, animated:Bool, completion:(() -> Void)?){
        presentCard(card, layout:CardLayoutEngine.sharedInstance.matchLayout(card), animated:animated, completion)
    }
    
    /// Presents a Card with a specific layout
    public func presentCard(card:Card, layout:WCCardLayout, animated:Bool, completion:(() -> Void)?){
        if(!card.supportsLayout(layout)){
            println("Unsupported layout for this card type, can't present.")
            return
        }
        let visualsource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card, width:nil)
        presentCard(card, customVisualSource: visualsource, animated: animated, completion: completion)
    }

    /// Presents a Card with a custom visual source
    public func presentCard(card:Card, customVisualSource:CardViewVisualSource, animated:Bool, completion:(() -> Void)? ){
        WildcardSDK.analytics?.trackEvent("CardPresented", withProperties: nil, withCard: card)
        
        let stockModal = StockModalCardViewController()
        stockModal.modalPresentationStyle = .Custom
        stockModal.transitioningDelegate = stockModal
        stockModal.modalPresentationCapturesStatusBarAppearance = true
        stockModal.presentedCard = card
        stockModal.cardVisualSource = customVisualSource
        presentViewController(stockModal, animated: animated, completion: completion)
    }

    /**
     Default handling of various Card Actions by a UIViewController. Includes presenting share sheets, appstore sheets, etc.
    
     It is recommended you use this UIViewController extension/category to handle card actions. If a UIViewController is a CardViewDelegate, you can use this function directly in cardViewRequestedAction. This is essential to making the buttons on your cards responsive.
    */
    public func handleCardAction(cardView:CardView, action:CardViewAction){
        switch(action.type){
        case WCCardAction.Collapse:
            if let maximizedController = self as? StockMaximizedCardViewController{
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            break
        case WCCardAction.Share:
            if let actionParams = action.parameters{
                let url = actionParams["url"] as NSURL
                let activityItems:[AnyObject] = [url]
                let appActivity = SafariActivity()
                let applicationActivities:[AnyObject] = [appActivity]
                let exclusionActivities:[AnyObject] = [UIActivityTypeAirDrop]
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
                activityViewController.excludedActivityTypes = exclusionActivities
                presentViewController(activityViewController, animated: true, completion: nil)
            }
            break
        case WCCardAction.Maximize:
            // only article cards can be maximized at the moment
            if(cardView.backingCard.type == .Article){
                let maximizeVisualSource = MaximizedArticleVisualSource(card: cardView.backingCard)
                maximizeCardView(cardView, visualsource: maximizeVisualSource)
            }
            break
        case WCCardAction.DownloadApp:
            if let actionParams = action.parameters{
                // can only use the Store Kit Controller if the current view controller conforms to delegate
                if let storeControllerDelegate = self as? SKStoreProductViewControllerDelegate{
                    let id = actionParams["id"] as NSString
                    var parameters = NSMutableDictionary()
                    parameters[SKStoreProductParameterITunesItemIdentifier] = id.integerValue
                    var storeController = SKStoreProductViewController()
                    storeController.delegate = storeControllerDelegate
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    storeController.loadProductWithParameters(parameters, completionBlock: { (bool:Bool, error:NSError!) -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.presentViewController(storeController, animated: true, completion: nil)
                        return
                    })
                    
                }else{
                    println("Unable to present the download sheet. This view controller does not conform to SKStoreProductViewControllerDelegate.")
                }
            }
            break
        case WCCardAction.ViewOnWeb:
            if let actionParams = action.parameters{
                if let url = actionParams["url"] as? NSURL{
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            break
        default:
            break
        }
    }
    
    /// ALPHA: Maximizes a CardView with a customized visual source
    public func maximizeCardView(cardView:CardView, visualsource:MaximizedCardViewVisualSource){
        
        let viewController = StockMaximizedCardViewController()
        viewController.presentingCardView = cardView
        viewController.modalPresentationStyle = .Custom
        viewController.transitioningDelegate = viewController
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.maximizedCard = cardView.backingCard
        viewController.maximizedCardVisualSource = visualsource
        
        if( Utilities.validateMaximizeVisualSource(visualsource)){
            presentViewController(viewController, animated: true, completion: nil)
        }else{
            println("Can not maximize CardView due to dimension mismatch")
        }
    }
    
    /// ALPHA: Presents an array of Cards as a swipeable Stack
    public func presentCardsAsStack(cards:[Card]){
        if(cards.count < 4){
            println("Can not present Deck with less than 4 Cards.")
            return
        }
        let deckController = StockModalDeckViewController()
        deckController.modalPresentationStyle = .Custom
        deckController.transitioningDelegate = deckController
        deckController.modalPresentationCapturesStatusBarAppearance = true
        deckController.cards = cards
        presentViewController(deckController, animated: true, completion: nil)
    }
    
}