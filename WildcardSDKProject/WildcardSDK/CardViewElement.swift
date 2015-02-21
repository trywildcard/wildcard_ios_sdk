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
    Used to determine variable height based on content. Returns UIViewNoIntrinsicMetric if no preferred width is set.
    
    Similar to UILabel.preferredMaxLayoutWidth, this width and is used in conjunction with optimizedHeight() to determine the intrinsic size of the CardViewElement
    */
    public var preferredWidth:CGFloat{
        get{
            return __preferredWidth
        }set{
            __preferredWidth = newValue
            adjustForPreferredWidth(__preferredWidth)
        }
    }
    
    /**
    Update the CardViewElement with the given card.

    This always happens before a final layout pass so you should not make any assumptions about frames or sizes during this call.
    */
    public func update(card:Card){
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(preferredWidth, optimizedHeight(preferredWidth))
    }
    
    /**
    Return an optimized height for the CardViewElement based on a given width. 
    
    This function should be overriden to provide a proper intrinsic size for this CardViewElement.
    */
    public func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return CGFloat.min
    }
    
    /**
    The preferred width of the card view element has just been updated, make any necessary adjustments

    e.g. Resassign a UILabel's preferredMaxLayoutWidth if it depends on the CardViewElement's preferredWidth
    */
    public func adjustForPreferredWidth(cardWidth:CGFloat){
        // override
    }
    
    /// Called automatically on init() or awakeFromNib()
    public func initialize(){
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