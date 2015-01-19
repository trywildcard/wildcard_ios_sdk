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
    public func presentCard(card:Card){
        presentCard(card, layout:CardLayoutEngine.sharedInstance.matchLayout(card))
    }
    
    /// Presents a Card with a specific layout
    public func presentCard(card:Card, layout:WCCardLayout){
        let datasource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card)
        presentCard(card, customVisualSource: datasource)
    }

    /// Presents a Card with a custom visual source
    public func presentCard(card:Card, customVisualSource:CardViewVisualSource){
        let stockModal = StockModalCardViewController()
        stockModal.modalPresentationStyle = .Custom
        stockModal.transitioningDelegate = stockModal
        stockModal.modalPresentationCapturesStatusBarAppearance = true
        stockModal.presentedCard = card
        stockModal.cardVisualSource = customVisualSource
        presentViewController(stockModal, animated: true, completion: nil)
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
    
    /**
     The default way a UIViewController handle various Card Actions
    
     It is recommended you use this from your UIViewControler of choice unless you are doing custom action handling.
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
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
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
        
        let initialFrame = view.convertRect(cardView.frame, fromView: cardView.superview)
        viewController.initialCardFrame = initialFrame
        
        if( Utilities.validateMaximizeVisualSource(visualsource)){
            presentViewController(viewController, animated: true, completion: nil)
        }else{
            println("Can not maximize CardView due to dimension mismatch")
        }
    }
}