//
//  ImageThumbnailFloatRight.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

class ImageThumbnail4x3FloatRight : CardViewElement
{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var kicker: UILabel!
    @IBOutlet weak var viewOnWeb: UIButton!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    override func initializeElement() {
        kicker.font = UIFont.defaultCardKickerFont()
        kicker.textColor = UIColor.wildcardMediumGray()
        title.font = UIFont.defaultCardTitleFont()
        title.textColor = UIColor.wildcardDarkBlue()
        viewOnWeb.styleAsExternalLink("VIEW ON WEB")
    }
    
    @IBAction func viewOnWebButtonTapped(sender: AnyObject) {
        cardView.handleViewOnWeb(backingCard.webUrl)
    }
    
    override func update() {
        
        if let summaryCard = cardView.backingCard as? SummaryCard{
            kicker.text = summaryCard.webUrl.host
            title.text = summaryCard.title
            
            // download image
            if let imageUrl = summaryCard.imageUrl{
                imageView.downloadImageWithURL(imageUrl, scale: UIScreen.mainScreen().scale, completion: { (image:UIImage?, error:NSError?) -> Void in
                    if(image != nil){
                        self.imageView.image = image
                        self.imageView.contentMode = UIViewContentMode.ScaleToFill
                    }else{
                        self.imageView.image = UIImage.loadFrameworkImage( "noImage")
                        self.imageView.contentMode = UIViewContentMode.Center
                    }
                })
            }
        }
    }
    
    override func optimizedHeight(cardWidth:CGFloat)->CGFloat{
        return imageViewHeight.constant + 20
    }
}