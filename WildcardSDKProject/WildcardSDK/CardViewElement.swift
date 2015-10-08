//
//  CardElement.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

/// The basic subcomponent of a CardView
@objc
public class CardViewElement : UIView {
    
    /// Reference to the parent CardView of the CardViewElement. Nil if this element has not been added to any CardView yet.
    public var cardView:CardView?
    
    /**
    Preferred width for the CardViewElement. Returns UIViewNoIntrinsicMetric if no preferred width is set.
    
    Similar to UILabel.preferredMaxLayoutWidth, this width and is used in conjunction with optimizedHeight() to determine the intrinsic size of the CardViewElement
    */
    public var preferredWidth:CGFloat{
        get{
            return __preferredWidth
        }set{
            __preferredWidth = newValue
            adjustForPreferredWidth(__preferredWidth)
            invalidateIntrinsicContentSize()
        }
    }
    
    /**
    Return an optimized height for the CardViewElement based on a given width.
    
    This function should be overriden to provide a proper intrinsic size for this CardViewElement. This height also affects the intrinsic size of a CardView if this element has been added to one
    */
    public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return CGFloat.min
    }
    
    /**
    Update the CardViewElement with the given card.

    This always happens before a final layout pass so you should not make any assumptions about frames or sizes during this call.
    */
    public func update(card:Card){
    }
    
    /**
    The preferred width of the card view element has just been updated, make any necessary adjustments

    e.g. Resassign a UILabel's preferredMaxLayoutWidth if it depends on the CardViewElement's preferredWidth
    */
    public func adjustForPreferredWidth(cardWidth:CGFloat){
        // override
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(preferredWidth, optimizedHeight(preferredWidth))
    }
    
    /// Called automatically on init() or awakeFromNib()
    public func initialize(){
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame:frame)
        initialize()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private var __preferredWidth:CGFloat = UIViewNoIntrinsicMetric
}