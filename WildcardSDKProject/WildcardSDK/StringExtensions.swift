//
//  StringExcetions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import Foundation

public extension String {
    public init(htmlEncodedString: String) {
        if let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding){
            let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            if let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil){
                self.init(attributedString.string)
            }else{
                self.init(htmlEncodedString)
            }
        }else{
            self.init(htmlEncodedString)
        }
    }
}
