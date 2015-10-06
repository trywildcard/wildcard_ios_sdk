//
//  CardViewAction.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/6/15.
//
//

import Foundation

@objc
public class CardViewAction: NSObject{
    
    /// Any parameters for the card action. e.g. for a WCCardAction.ViewOnWeb, there is a url parameter
    public let parameters:NSDictionary?
    
    /// Action type. See WCCardAction
    public let type:WCCardAction
    
    /// Init
    public init(type:WCCardAction, parameters:NSDictionary?){
        self.type = type
        self.parameters = parameters
    }
}