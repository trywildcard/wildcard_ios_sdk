//
//  BaseVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/30/15.
//
//

import Foundation

/// DO NOT instantiate. You may derive from this if you are customizing your own visual source.

public class BaseVisualSource
{
    var card:Card
    
    /// Initiailize with backing card and card margin to screen bounds
    public init(card:Card){
        self.card = card
    }
}