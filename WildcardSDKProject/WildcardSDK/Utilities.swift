//
//  Utilities.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation

public class Utilities{
    public class func printFontFamilies()
    {
        for name in UIFont.familyNames()
        {
            if let nameString = name as? String{
                let names = UIFont.fontNamesForFamilyName(nameString)
                println(nameString)
                println(names)
            }
        }
    }
}