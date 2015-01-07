//
//  CardElement.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class CardViewElement : UIView {
    
    var cardView:CardView!
    
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
    Optionally return an optimized height for this element given a width + card
    */
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