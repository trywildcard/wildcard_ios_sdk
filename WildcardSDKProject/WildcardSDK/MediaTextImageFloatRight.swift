//
//  MediaTextImageFloatRight.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class MediaTextImageFloatRight : CardViewElement{
    
    @IBOutlet weak var textContainer: UITextView!
    @IBOutlet weak var cardImage: UIImageView!
    
    override func initializeElement(){
        
        textContainer.textContainerInset = UIEdgeInsetsMake(-5, 0, 0, 0)
        textContainer.scrollEnabled = false
        textContainer.textContainer.lineFragmentPadding = 0
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
            let convert = textContainer.convertRect(cardImage.frame, fromView: self)
            let exclusionRect = CGRectMake(convert.origin.x - 10, 0, convert.size.width + 10, convert.size.height)
            let exclusionPath = UIBezierPath(rect: exclusionRect)
            textContainer.textContainer.exclusionPaths = [exclusionPath]
            
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
        
        setNeedsLayout()
    }
    
}