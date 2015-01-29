//
//  WebLinkCard.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

/**
Summary Card
*/
@objc
public class SummaryCard : Card {
    
    public let title:String
    public let abstractContent:String
    public let imageUrl:NSURL?
    
    public init(url:NSURL, description:String, title:String, imageUrl:NSURL?){
        self.title = String(htmlEncodedString: title)
        self.abstractContent = String(htmlEncodedString: description)
        self.imageUrl = imageUrl
        super.init(webUrl: url, cardType: "summary")
    }
    
    override class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        var summaryCard:SummaryCard?
        var startURL:NSURL?
        var title:String?
        var description:String?
        
        if let urlString = data["startUrl"] as? String{
            startURL = NSURL(string:urlString)
        }
        
        if let summary = data["summary"] as? NSDictionary{
            title = summary["title"] as? String
            description = summary["description"] as? String
            if(title != nil && startURL != nil && description != nil){
                
                var imageURL:NSURL?
                if let image = summary["image"] as? NSDictionary{
                    if let imageSrc = image["src"] as? String{
                        imageURL = NSURL(string:imageSrc)
                    }
                }
                summaryCard = SummaryCard(url: startURL!, description: description!, title: title!, imageUrl: imageURL)
            }
        }
        return summaryCard
    }
    
    public class func createFromUrl(url:NSURL, completion: ((SummaryCard?, NSError?)->Void)) -> Void{
        Platform.sharedInstance.createSummaryCardFromUrl(url,completion:completion)
    }
}