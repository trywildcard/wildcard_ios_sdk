//
//  MediaTextImageFloatRight.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class MediaTextImageFloatRight : CardViewElement{
    
    @IBOutlet weak public var textContainer: UITextView!
    @IBOutlet weak public var cardImage: UIImageView!
    
    override func initializeElement(){
        
        textContainer.scrollEnabled = false
        textContainer.textContainer.lineFragmentPadding = 0
        textContainer.textContainerInset = UIEdgeInsetsZero
        cardImage.contentMode = UIViewContentMode.ScaleAspectFill
        cardImage.layer.cornerRadius = 2.0
        cardImage.layer.masksToBounds = true
    }
    
    override func update() {
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
            attributedText.setLineHeight(UIFont.wildcardStandardHeaderFontLineHeight())
            attributedText.setFont(UIFont.wildcardStandardMediaBodyFont())
            attributedText.setColor(UIColor.wildcardMediaBodyFont())
            textContainer.attributedText = attributedText
        }
        
        // download image
        if imageUrl != nil {
            cardImage.hidden = false
            cardImage.downloadImageWithURL(imageUrl!, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                if(image != nil){
                    self.cardImage.image = image
                }else{
                    self.cardImage.image = UIImage(named: "noImage")
                    self.cardImage.contentMode = UIViewContentMode.Center
                }
            })
        }else{
            cardImage.hidden = true
        }
        
    }
    
    override func cardViewFinishedLayout() {
        if let card = backingCard as? ArticleCard{
            if let hasUrl = card.primaryImageURL{
                let convert = textContainer.convertRect(cardImage.frame, fromView: self)
                let exclusionRect = CGRectMake(convert.origin.x - 10, 0, convert.size.width + 10, convert.size.height)
                let exclusionPath = UIBezierPath(rect: exclusionRect)
                textContainer.textContainer.exclusionPaths = [exclusionPath]
                
            }else{
                textContainer.textContainer.exclusionPaths = []
            }
        }
    }
}