//
//  StringExcetions.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import Foundation

extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        if let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil){
            self.init(attributedString.string)
        }else{
            self.init(htmlEncodedString)
        }
    }
}
