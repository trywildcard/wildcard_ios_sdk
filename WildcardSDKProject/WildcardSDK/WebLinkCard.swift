//
//  WebLinkCard.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

/*
* WebLink Card
*
* Official Schema:
* http://www.trywildcard.com/docs/schema/#weblink-card
*
*/
public class WebLinkCard : Card {
    
    var title:String
    var description:String
    
    var imageUrl:NSURL?
    
    public init(url:NSURL, description:String, title:String, dictionary:NSDictionary?){
        self.title = title
        self.description = description
        super.init(webUrl: url, cardType: "weblink")
        
        if let image = dictionary?["primaryImageUrl"] as? String{
            imageUrl = NSURL(string: image)
        }
        if let image = dictionary?["og:image"] as? String{
            imageUrl = NSURL(string: image)
        }
    }
    
    public class func createFromWebUrl(url:NSURL, completion: ((WebLinkCard?, NSError?)->Void)) -> Void{
        Platform.sharedInstance.getWebLinkCardFromWebUrl(url,completion:completion)
    }
    
    
}