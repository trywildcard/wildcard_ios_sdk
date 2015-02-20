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
    
    /// Reference to the parent CardView of the CardViewElement. Nil if this element has not been added to any CardView yet.
    public var cardView:CardView?
    
    /// Used to determine variable height based on content. Returns UIViewNoIntrinsicMetric if no preferred width is set.
    public var preferredWidth:CGFloat{
        get{
            return __preferredWidth
        }set{
            __preferredWidth = newValue
            adjustForPreferredWidth(__preferredWidth)
        }
    }
    
    /// Called after the CardViewElement is initialized or after awakeFromNib
    public func initialize(){
    }
    
    /**
    Update the CardViewElement with the given card.

    Layout has not finished yet so can not make any assumptions about frames or sizes
    */
    public func update(card:Card){
    }
    
    // Intrinsic content size of a card element will always be the preferredWidth w/ optimizedHeight(preferredWidth) as the height
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(preferredWidth, optimizedHeight(preferredWidth))
    }
    
    /**
    Return an optimized height for the CardViewElement based on a given width. 
    
    This should be implemented to give each card element a proper intrinsic size.
    */
    public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return CGFloat.min
    }
    
    /**
    The CardView parent has finished laying out. 
    
    Can do any last minute changes to the CardViewElement that may depend on frame/bounds e.g. exclusion paths, etc.
    */
    public func cardViewFinishedLayout(){
    }

    /**
    The preferred width of the card view element has just been updated, make any necessary adjustments

    e.g. if a UILabel has a preferredMaxLayoutWidth that depends on the preferred width
    */
    
    public func adjustForPreferredWidth(cardWidth:CGFloat){
        // override
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame:frame)
        initialize()
    }
    
    public override init(){
        super.init()
        initialize()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private var __preferredWidth:CGFloat = UIViewNoIntrinsicMetric
}