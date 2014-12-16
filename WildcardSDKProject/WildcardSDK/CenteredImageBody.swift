//
//  CenteredImageBody.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class CenteredImageBody : CardViewElement{
    
    var cardImage:UIImageView!
    
    override func initializeElement(){
        cardImage = UIImageView(frame: CGRectZero)
        cardImage.backgroundColor = UIColor.wildcardBackgroundGray()
        addSubview(cardImage)
        cardImage.verticallyCenterToSuperView(0)
        addConstraint(NSLayoutConstraint(item: cardImage, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: cardImage, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20))
        addConstraint(NSLayoutConstraint(item: cardImage, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 180))
    }
    
    override func updateForCard(card: Card) {
        
        var imageUrl:NSURL?
        
        switch(card.type){
        case .Article:
            let articleCard = card as ArticleCard
            imageUrl = articleCard.primaryImageURL
        case .WebLink:
            let webLinkCard = card as WebLinkCard
            imageUrl = webLinkCard.imageUrl
        case .Unknown:
            imageUrl = nil
        }
        
        // download image
        if imageUrl != nil {
            cardImage.downloadImageWithURL(imageUrl!, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                if(image != nil){
                    self.cardImage.image = image
                }else{
                    self.cardImage.image = UIImage(named: "noImage")
                    self.cardImage.contentMode = UIViewContentMode.Center
                }
            })
        }
        
    }
    
    override class func optimizedHeight(cardWidth:CGFloat, card:Card)->CGFloat{
        return 200
    }
    
}