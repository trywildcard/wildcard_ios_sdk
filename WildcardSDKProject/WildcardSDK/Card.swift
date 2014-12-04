//
//  Card.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/3/14.
//
//

import Foundation

@objc
public class Card {
    let webUrl:NSURL
    let cardType:String
    
    init(webUrl:NSURL, cardType:String){
        self.webUrl = webUrl
        self.cardType = cardType
    }
}