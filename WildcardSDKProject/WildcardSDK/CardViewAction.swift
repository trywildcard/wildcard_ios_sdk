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
    public enum Type{
        case Maximize
        case Collapse
        case DownloadApp
        case Custom
    }
    
    public var parameters:NSDictionary?
    public var type:Type
    
    public init(type:Type, parameters:NSDictionary?){
        self.type = type
        self.parameters = parameters
    }
}