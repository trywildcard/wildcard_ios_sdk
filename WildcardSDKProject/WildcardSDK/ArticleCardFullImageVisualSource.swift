//
//  ArticleCardFullImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public class ArticleCardFullImageVisualSource : BaseVisualSource {
    
    var header:FullCardHeader
    var body:ImageAndCaptionBody
    var footer:ReadMoreFooter
    var aspectRatio:CGFloat
    
    public init(card:Card, aspectRatio:CGFloat){
        self.aspectRatio = aspectRatio
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.header.hairline.hidden = true
       // self.header.titleOffset = UIOffsetMake(15, self.header.titleOffset.vertical)
        self.body = UIView.loadFromNibNamed("ImageAndCaptionBody") as ImageAndCaptionBody
        self.body.contentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15)
        self.body.imageAspectRatio = aspectRatio
        self.footer = ReadMoreFooter(frame:CGRectZero)
        self.footer.readMoreButtonOffset = UIOffsetMake(15, 0)
        super.init(card:card)
    }
    
    public func viewForCardHeader()->CardViewElement?{
        return header
    }
    
    public func heightForCardHeader()->CGFloat{
        return header.optimizedHeight(widthForCard())
    }
    
    public override func viewForCardBody()->CardViewElement{
        return body
    }
    
    public override func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        return footer
    }
    
    public func heightForCardFooter() -> CGFloat {
        return 60
    }
}