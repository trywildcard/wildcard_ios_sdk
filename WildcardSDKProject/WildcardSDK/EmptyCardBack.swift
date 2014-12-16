//
//  EmptyCardBack.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class EmptyCardBack : CardViewElement {
    
    var titleLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        convenienceInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        convenienceInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        convenienceInit()
    }
    
    func convenienceInit(){
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = NSTextAlignment.Center
        addSubview(titleLabel)
        titleLabel.verticallyCenterToSuperView(-4)
        titleLabel.horizontallyCenterToSuperView(0)
        titleLabel.font = UIFont.wildcardStandardHeaderFont()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "The Back!"
        backgroundColor = UIColor.wildcardDarkBlue()
    }
    
    override func updateForCard(card: Card) {
        // nothing
    }
}