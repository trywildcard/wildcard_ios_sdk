//
//  CardViewAction.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/6/15.
//
//

import Foundation

@objc
public class CardViewAction{
    
    public var parameters:NSDictionary?
    public var type:WCCardAction
    
    public init(type:WCCardAction, parameters:NSDictionary?){
        self.type = type
        self.parameters = parameters
    }
}