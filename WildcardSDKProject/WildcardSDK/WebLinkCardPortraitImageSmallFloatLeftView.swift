//
//  WebLinkCardPortraitImageSmallFloatLeftView.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/10/14.
//
//

import Foundation

class WebLinkCardPortraitImageSmallFloatLeftView : CardContentView{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomHairline: UIView!
    @IBOutlet weak var viewOnWebButton: UIButton!
    @IBOutlet weak var cardImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        associatedLayout = CardLayout.WebLinkCardPortraitDefault
        bottomHairline.backgroundColor = UIColor.wildcardBackgroundGray()
        titleLabel.textColor = UIColor.wildcardDarkBlue()
        titleLabel.font = UIFont.wildcardStandardHeaderFont()
    }

    override func updateViewForCard(card:Card){
        var imageUrl:NSURL?
        var titleText:String?
        
        if let webLinkCard = card as? WebLinkCard{
            titleLabel.setAsCardHeaderWithText(String(htmlEncodedString: webLinkCard.title))
            descriptionLabel.setAsCardSubHeaderWithText(String(htmlEncodedString: webLinkCard.description))
            
            // download image
            if let imageUrl = webLinkCard.imageUrl{
                let imageRequest:NSURLRequest = NSURLRequest(URL: imageUrl)
                if let cachedImage = ImageCache.sharedInstance.cachedImageForRequest(imageRequest){
                    cardImageView.image = cachedImage
                }else{
                    var downloadTask:NSURLSessionDownloadTask =
                    NSURLSession.sharedSession().downloadTaskWithRequest(imageRequest,
                        completionHandler: { (location:NSURL!, resp:NSURLResponse!, error:NSError!) -> Void in
                            if(error == nil){
                                let data:NSData? = NSData(contentsOfURL: location)
                                if let newImage = UIImage(data: data!, scale: UIScreen.mainScreen().scale){
                                    ImageCache.sharedInstance.cacheImageForRequest(newImage, request: imageRequest)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.cardImageView.image = newImage
                                    })
                                }else{
                                    let error = NSError(domain: "Couldn't create image from data", code: 0, userInfo: nil)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.cardImageView.image = UIImage(named: "noImage")
                                        self.cardImageView.contentMode = UIViewContentMode.Center
                                    })
                                }
                            }else{
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.cardImageView.image = UIImage(named: "noImage")
                                    self.cardImageView.contentMode = UIViewContentMode.Center
                                })
                            }
                    })
                    downloadTask.resume()
                }
                
            }
        }
    }
    
    
    override func optimalBounds() -> CGRect {
        let screenBounds = UIScreen.mainScreen().bounds
        let cardWidth = screenBounds.width - (2*CardContentView.DEFAULT_HORIZONTAL_MARGIN)
        return CGRectMake(0,0,cardWidth, 180)
    }
    
}