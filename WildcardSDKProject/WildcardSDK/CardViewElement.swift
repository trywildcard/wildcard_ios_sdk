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
    
    /// Reference to CardView if the CardViewElement has been laid out inside one
    public var cardView:CardView!
    public var preferredWidth:CGFloat!
    public var backingCard:Card{
        get{
            return cardView.backingCard
        }
    }
    
    /// Called after the CardViewElement is initialized or after awakeFromNib
    public func initializeElement(){
    }
    
    /**
    Update the CardViewElement with the current backing card. 

    Layout has not finished yet so can not make any assumptions about frames or sizes
    */
    public func update(){
    }
    
    /**
    Return an optimized height for the CardViewElement based on a given width.
    
    This is called after an update(), but before the CardView has finished layingout. Use autolayout constraints, width, and most recent data to determine a height.
    */
    public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return CGFloat.min
    }
    
    /**
    The CardView has finished laying out. Can do any last minute changes to the CardViewElement that may depend on frame sizes e.g. exclusion paths, etc.
    */
    public func cardViewFinishedLayout(){
    }
    
    /*
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
    */
    
}