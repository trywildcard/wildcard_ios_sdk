//
//  MediaTextImageFloatRight.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class MediaTextImageFloatRight : CardViewElement{
    
    @IBOutlet weak public var cardImage: WCImageView!
    @IBOutlet weak public var textContainer: UITextView!
    
    public var textContainerEdgeInsets:UIEdgeInsets{
        get{
            return UIEdgeInsetsMake(topConstraint.constant, leftConstraint.constant, bottomConstraint.constant, rightConstraint.constant)
        }
        set{
            topConstraint.constant = newValue.top
            leftConstraint.constant = newValue.left
            rightConstraint.constant = newValue.right
            bottomConstraint.constant = newValue.bottom
        }
    }
    
    @IBOutlet weak private var topConstraint: NSLayoutConstraint!
    @IBOutlet weak private var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak private var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    
    override public func initializeElement(){
        textContainer.scrollEnabled = false
        textContainer.textContainer.lineFragmentPadding = 0
        textContainer.textContainerInset = UIEdgeInsetsZero
        cardImage.contentMode = UIViewContentMode.ScaleAspectFill
        cardImage.layer.cornerRadius = 2.0
        cardImage.layer.masksToBounds = true
    }
    
    override public func update() {
        super.update()
        
        var imageUrl:NSURL?
        var abstractContent:String?
        
        switch(cardView.backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            imageUrl = articleCard.primaryImageURL
            abstractContent = articleCard.abstractContent
        case .Summary:
            let summaryCard = cardView.backingCard as SummaryCard
            imageUrl = summaryCard.imageUrl
            abstractContent = summaryCard.description
        case .Unknown:
            imageUrl = nil
        }
        
        if(abstractContent != nil){
            var attributedText = NSMutableAttributedString(string: abstractContent!)
            attributedText.setColor(UIColor.wildcardMediaBodyColor())
            textContainer.attributedText = attributedText
        }
        
        // download image
        if imageUrl != nil {
            cardImage.setImageWithURL(imageUrl!, mode:.ScaleAspectFill)
        }
    }
    
    override public func cardViewFinishedLayout() {
        let convert = textContainer.convertRect(cardImage.frame, fromView: self)
        let exclusionRect = CGRectMake(convert.origin.x - 10, 0, convert.size.width + 10, convert.size.height)
        let exclusionPath = UIBezierPath(rect: exclusionRect)
        textContainer.textContainer.exclusionPaths = [exclusionPath]
    }
}