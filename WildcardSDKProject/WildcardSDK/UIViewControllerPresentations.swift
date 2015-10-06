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
    public func presentCard(card:Card!, animated:Bool, completion:(() -> Void)?){
        if let card = card {
            presentCard(card, layout:CardLayoutEngine.sharedInstance.matchLayout(card), animated:animated, completion:completion)
        }else{
            print("Can't present a nil card")
        }
    }
    
    /// Presents a Card with a specific layout
    public func presentCard(card:Card!, layout:WCCardLayout, animated:Bool, completion:(() -> Void)?){
        if let card = card{
            if(!card.supportsLayout(layout)){
                print("Unsupported layout for this card type, can't present.")
                return
            }
            let visualsource = CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card)
            presentCard(card, customVisualSource: visualsource, animated: animated, completion: completion)
        }else{
            print("Can't present a nil card")
        }
    }

    /// Presents a Card with a custom visual source
    public func presentCard(card:Card!, customVisualSource:CardViewVisualSource, animated:Bool, completion:(() -> Void)? ){
        WildcardSDK.analytics?.trackEvent("CardPresented", withProperties: nil, withCard: card)
        if let card = card {
            let modal = StockModalCardViewController()
            modal.modalPresentationStyle = .Custom
            modal.transitioningDelegate = modal
            modal.modalPresentationCapturesStatusBarAppearance = true
            modal.presentedCard = card
            modal.cardVisualSource = customVisualSource
            self.presentViewController(modal, animated: animated, completion: completion)
        }else{
            print("Can't present a nil card")
        }
    }

    /**
     Default handling of various Card Actions by a UIViewController. Includes presenting share sheets, appstore sheets, etc.
    
     It is recommended you use this UIViewController extension/category to handle card actions. If a UIViewController is a CardViewDelegate, you can use this function directly in cardViewRequestedAction. This is essential to making the buttons on your cards responsive.
    */
    public func handleCardAction(cardView:CardView, action:CardViewAction){
        switch(action.type){
        case WCCardAction.Collapse:
            if let _ = self as? StockMaximizedCardViewController{
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            break
        case WCCardAction.Share:
            if let actionParams = action.parameters{
                if let url = actionParams["url"] as? NSURL{
                    let activityItems:[AnyObject] = [url]
                    let appActivity = SafariActivity()
                    let applicationActivities:[UIActivity] = [appActivity]
                    let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
                    activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
                    presentViewController(activityViewController, animated: true, completion: nil)
                }
            }
            break
        case WCCardAction.Maximize:
            // only article cards can be maximized at the moment
            if(cardView.backingCard.type == .Article){
                let maximizeVisualSource = MaximizedArticleVisualSource(card: cardView.backingCard)
                maximizeCardView(cardView, maximizedVisualSource: maximizeVisualSource)
            }
            break
        case WCCardAction.DownloadApp:
            if let actionParams = action.parameters{
                // can only use the Store Kit Controller if the current view controller conforms to delegate
                if let storeControllerDelegate = self as? SKStoreProductViewControllerDelegate{
                    if let id = actionParams["id"] as? NSString{
                        var parameters = [String: AnyObject]()
                        parameters[SKStoreProductParameterITunesItemIdentifier] = id.integerValue
                        let storeController = SKStoreProductViewController()
                        storeController.delegate = storeControllerDelegate
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                        storeController.loadProductWithParameters(parameters, completionBlock: { (bool:Bool, error:NSError?) -> Void in
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            self.presentViewController(storeController, animated: true, completion: nil)
                            return
                        })
                    }
                }else{
                    print("Unable to present the download sheet. This view controller does not conform to SKStoreProductViewControllerDelegate.")
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
        case WCCardAction.ImageTapped:
            // default behavior for this action is to present a full screen view of the image. entering and exiting full screen will have callbacks
            if let actionParams = action.parameters{
                if let imageView = actionParams["tappedImageView"] as? WCImageView{
                    if(imageView.image != nil){
                        let controller = StockImageViewViewController()
                        controller.fromCardView = cardView
                        controller.fromImageView = imageView
                        controller.modalPresentationCapturesStatusBarAppearance = true
                        controller.modalPresentationStyle = .Custom
                        controller.transitioningDelegate = controller
                        presentViewController(controller, animated: true, completion: { () -> Void in
                            cardView.delegate?.cardViewRequestedAction?(cardView, action: CardViewAction(type: .ImageDidEnterFullScreen, parameters: nil))
                            return
                        })
                    }
                }
            }
        default:
            break
        }
    }
    
    /// ALPHA: Maximizes a CardView with a customized visual source
    public func maximizeCardView(cardView:CardView, maximizedVisualSource:MaximizedCardViewVisualSource){
        
        let viewController = StockMaximizedCardViewController()
        viewController.presentingCardView = cardView
        viewController.modalPresentationStyle = .Custom
        viewController.transitioningDelegate = viewController
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.maximizedCard = cardView.backingCard
        viewController.maximizedCardVisualSource = maximizedVisualSource
        
        presentViewController(viewController, animated: true, completion: nil)
    }
    
}