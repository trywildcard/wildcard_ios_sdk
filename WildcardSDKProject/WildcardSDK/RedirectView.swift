//
//  RedirectView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/9/15.
//
//

import Foundation

class PassthroughView: UIView {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
    {
        // pass through touches
        let hitView = super.hitTest(point, withEvent:event)
        if(hitView == self){
            return nil
        }
        return hitView
    }
    
}