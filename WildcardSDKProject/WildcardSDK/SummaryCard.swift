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
public class SummaryCard : Card {
    
    public let title:String
    public let description:String
    public let imageUrl:NSURL?
    
    public init(url:NSURL, description:String, title:String, imageUrl:NSURL?){
        self.title = String(htmlEncodedString: title)
        self.description = String(htmlEncodedString: description)
        self.imageUrl = imageUrl
        super.init(webUrl: url, cardType: "summary")
    }
    
    override class func deserializeFromData(data: NSDictionary) -> AnyObject? {
        // TODO when there's real Summary Cards
        return nil;
    }
    
    public class func createFromUrl(url:NSURL, completion: ((SummaryCard?, NSError?)->Void)) -> Void{
        Platform.sharedInstance.createSummaryCardFromUrl(url,completion:completion)
    }
}