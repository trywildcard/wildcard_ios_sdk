//
//  ImageThumbnailFloatLeft.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class ImageThumbnailFloatLeft : CardViewElement
{
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func initializeElement() {
        
    }
    
    override func updateForCard(card: Card) {
        var imageUrl:NSURL?
        var titleText:String?
        
        if let webLinkCard = card as? WebLinkCard{
            cardTitle.setAsCardHeaderWithText(String(htmlEncodedString: webLinkCard.title))
            cardDescription.setAsCardSubHeaderWithText(String(htmlEncodedString: webLinkCard.description))
            
            // download image
            if let imageUrl = webLinkCard.imageUrl{
                thumbnail.downloadImageWithURL(imageUrl, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.thumbnail.image = image
                    }else{
                        self.thumbnail.image = UIImage(named: "noImage")
                        self.thumbnail.contentMode = UIViewContentMode.Center
                    }
                })
            }
        }
    }
    
    override class func optimizedHeight(cardWidth:CGFloat, card:Card)->CGFloat{
        return 140
    }
    
}