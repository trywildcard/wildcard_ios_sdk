//
//  CardView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation
import UIKit
import QuartzCore

public class CardView : UIView
{
    let containerView:UIView
    var contentView:CardContentView?
    
    // MARK: UIView
    override init(frame: CGRect) {
        self.containerView = UIView()
        super.init(frame: frame)
        convenienceInitialize()
    }
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        
        // reset shadow path
        let path = UIBezierPath(rect: bounds)
        layer.shadowPath =  path.CGPath
    }
    
    required public init(coder: NSCoder) {
        self.containerView = UIView()
        super.init(coder: coder)
        convenienceInitialize()
    }
    
    // MARK: Instance
    func initializeContentView(cardContentView:CardContentView){
        if(contentView != nil){
            contentView!.removeFromSuperview()
            contentView = nil
        }
        
        bounds =  cardContentView.optimalBounds()
        layoutIfNeeded()
        
        containerView.addSubview(cardContentView)
        cardContentView.constrainToSuperViewEdges()
    }
    
    func finalizeCard(){
        // set original always at 0,0
        frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
    }
    
    // MARK: Private
    func convenienceInitialize(){
        
        backgroundColor = UIColor.clearColor()
        containerView.backgroundColor = UIColor.clearColor()
        containerView.layer.cornerRadius = 2.0
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        containerView.constrainToSuperViewEdges()
        
        // drop shadow
        layer.shadowColor = UIColor(red: 157/255, green: 163/255, blue: 178/255, alpha: 1.0).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSizeMake(0, 2.0)
        layer.shadowRadius = 2.0
    }
    
}