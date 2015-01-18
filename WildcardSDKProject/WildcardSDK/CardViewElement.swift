//
//  CardElement.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

@objc
public class CardViewElement : UIView {
    
    var cardView:CardView!
    var backingCard:Card{
        get{
            return cardView.backingCard
        }
    }
    
    /**
    Override this function to update the CardViewElement based on the current backing Card
    */
    func update(){
    }
    
    /**
    Override to initialize any parts of the CardViewElement. This is called automatically 
    whenever the view is initialized.
    */
    func initializeElement(){
    }
    
    /**
    Override this function to get notified when the card view finishes laying out
    */
    func cardViewFinishedLayout(){
    }
    
    /**
    Optionally return an optimized height for this element given a width
    */
    func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return CGFloat.min
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeElement()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        initializeElement()
    }
}