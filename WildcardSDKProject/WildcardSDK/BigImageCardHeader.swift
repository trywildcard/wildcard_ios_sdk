//
//  BigImageCardHeader.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/24/15.
//
//

import Foundation

class BigImageCardHeader : CardViewElement
{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var kicker: UILabel!
    var hairline:UIView!
    
    override func initializeElement() {
        
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        kicker.font =  WildcardSDK.cardKickerFont
        kicker.textColor = UIColor.wildcardMediumGray()
        title.font = WildcardSDK.cardTitleFont
        title.textColor = UIColor.wildcardDarkBlue()
        hairline = addBottomBorderWithWidth(1.0, color: UIColor.wildcardBackgroundGray())
    }
    
    override func update() {
        switch(backingCard.type){
        case .Article:
            let articleCard = cardView.backingCard as ArticleCard
            kicker.text = articleCard.publisher.name
            title.text = articleCard.title
            if let url = articleCard.primaryImageURL {
                imageView.downloadImageWithURL(url, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.imageView.image = image!
                    }
                })
            }
        case .Summary:
            let summaryCard = cardView.backingCard as SummaryCard
            kicker.text = summaryCard.webUrl.host
            title.text = summaryCard.title
            if let url = summaryCard.imageUrl {
                imageView.downloadImageWithURL(url, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.imageView.image = image!
                    }
                })
            }
        case .Unknown:
            title.text = "Unknown Card Type"
            kicker.text = "Unknown Card Type"
            imageView.image = UIImage.loadFrameworkImage("wildcardSmallLogo")
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        
        return 110
    }
}