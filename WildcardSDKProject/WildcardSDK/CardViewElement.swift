//
//  CardElement.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

@objc
protocol CardViewElementDelegate
{
    optional func cardViewElementRequestedViewOnWeb()
    optional func cardViewElementRequestedReadMore()
    optional func cardViewElementRequestedToClose()
}

public class CardViewElement : UIView {
    
    var backingCard:Card?
    var delegate:CardViewElementDelegate?
    
    func updateForCard(card:Card){
        backingCard = card
        // override
    }
    
    func initializeElement(){
        // override
    }
    
    class func optimizedHeight(cardWidth:CGFloat, card:Card)->CGFloat{
        // optionally return an optimized height for this element given a width + card
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