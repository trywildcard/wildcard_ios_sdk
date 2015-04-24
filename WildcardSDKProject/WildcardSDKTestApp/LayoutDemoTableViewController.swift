//
//  LayoutDemoTableViewController.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/15/15.
//
//

import UIKit
import WildcardSDK

class LayoutDemoTableViewController: UITableViewController {

    var summaryCard:SummaryCard!
    var videoCard:VideoCard!
    var imageCard:ImageCard!
    var articleCard:ArticleCard!
    var summaryCardTwitterTweet:SummaryCard!
    var summaryCardTwitterProfile:SummaryCard!
    
    var layoutLabels:[String] =
    [
        "SummaryCard",
        "SummaryCard",
        "SummaryCard",
        "SummaryCard",
        "SummaryCard",
        "VideoCard",
        "VideoCard",
        "VideoCard",
        "ImageCard",
        "ImageCard",
        "ImageCard",
        "ArticleCard",
        "ArticleCard",
        "ArticleCard",
        "SummaryCard",
        "SummaryCard"
    ]
    
    var layoutLabelsSubtexts:[String] =
    [
        "No Image",
        "Tall",
        "Short",
        "Short Left",
        "Image Only",
        "Short",
        "Short Full Bleed",
        "Thumbnail",
        "4x3",
        "Aspect Fit",
        "Image Only",
        "No Image",
        "Tall",
        "Short",
        "Twitter Tweet",
        "Twitter Profile"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let media:NSMutableDictionary = NSMutableDictionary()
        let mediaDescription:NSMutableDictionary = NSMutableDictionary()
        mediaDescription["description"] = "This is a dummy card label. The quick brown fox jumped over the lazy dog."
        media["imageUrl"] = "http://images.mid-day.com/2013/mar/shark-attack.jpg"
        media["type"] = "image"
        
        let yahoo = NSURL(string: "http://www.yahoo.com")!
        summaryCard = SummaryCard(url:yahoo, description: "Yahoo is a veteran of the Internet. They recently spinned off a company called SpinCo to avoid paying billions of dollars in taxes for their stake in Alibaba.", title: "The quick brown fox jumped over the lazy dog. Yahoo Spinning Off SpinCo", media:media, data:nil)
        
        
        let url = NSURL(string: "http://www.youtube.com")!
        let embedUrl = NSURL(string: "https://www.youtube.com/embed/L0WFKiuwUUQ")!
        let vidwebUrl = NSURL(string: "https://www.youtube.com/watch?v=L0WFKiuwUUQ")!
        let youtube = Creator(name:"Youtube", url:url, favicon:NSURL(string:"http://coopkanicstang-development.s3.amazonaws.com/brandlogos/logo-youtube.png"), iosStore:nil)
        
        let videoData:NSMutableDictionary = NSMutableDictionary()
        let videoMedia:NSMutableDictionary = NSMutableDictionary()
        videoMedia["description"] =  "Subscribe to TRAILERS: http://bit.ly/sxaw6h Subscribe to COMING SOON: http://bit.ly/H2vZUn Like us on FACEBOOK: http://goo.gl/dHs73 Follow us on TWITTER: htt..."
        videoMedia["posterImageUrl"] =  "https://i.ytimg.com/vi/L0WFKiuwUUQ/maxresdefault.jpg"
        videoData["media"] = videoMedia
        
        // article card no image has default
        let data:NSMutableDictionary = NSMutableDictionary()
        videoCard = VideoCard(title: "Avengers: Age of Ultron Official Extended TV SPOT - Let's Finish This (2015) - Avengers Sequel HD", embedUrl: embedUrl, url: vidwebUrl, creator: youtube, data: videoData)
        
        
        let imgurUrl = NSURL(string: "http://www.imgur.com")!
        let imgur = Creator(name:"Imgur", url:imgurUrl, favicon:NSURL(string:"https://pbs.twimg.com/profile_images/430460875661537280/4CX-Iah3.png"), iosStore:nil)
        
        let imageData:NSMutableDictionary = NSMutableDictionary()
        let imageMedia:NSMutableDictionary = NSMutableDictionary()
        imageMedia["imageUrl"] =  "https://i.imgur.com/ZvEWNki.png"
        imageMedia["imageCaption"] = "We&#039;re nominated for two Webby awards! And when we say &quot;we,&quot; we really mean you - the front lines of the Internet, curating the most awesome images and stories for all to see. Let&#039;s show &#039;em that Imgurians are the best community on the Internet by casting our votes. Here&#039;s where: Social Media: &lt;a href=&quot;http://pv.webbyawards.com/2015/web/general-website/social-media&quot;&gt;http://pv.webbyawards.com/2015/web/general-website/social-media&lt;/a&gt;  Community: &lt;a href=&quot;http://pv.webbyawards.com/2015/web/general-website/community&quot;&gt;http://pv.webbyawards.com/2015/web/general-website/community&lt;/a&gt;  "
        imageMedia["title"] = "Vote for Imgur!"
        imageMedia["width"] = 4796
        imageMedia["height"] = 4796
        imageData["media"] = imageMedia
        
        imageCard = ImageCard(imageUrl: NSURL(string:"https://i.imgur.com/ZvEWNki.png")!, url: NSURL(string:"http://imgur.com/gallery/ZvEWNki")!, creator: imgur, data: imageData)
        
        let cnnUrl = NSURL(string: "http://www.cnn.com")!
        let cnn = Creator(name:"CNN", url:imgurUrl, favicon:NSURL(string:"http://coopkanicstang-development.s3.amazonaws.com/brandlogos/logo-cnn.png"), iosStore:nil)
        
        
        let articleURL = NSURL(string:"http://money.cnn.com/2015/04/14/technology/high-there-dating-app/index.html")!
        let articleData:NSMutableDictionary = NSMutableDictionary()
        let articleBaseData:NSMutableDictionary = NSMutableDictionary()
        articleData["htmlContent"] = "<div>Some Content</div>"
        articleData["publicationDate"] = 1429063354000
        let articleMedia:NSMutableDictionary = NSMutableDictionary()
        articleMedia["imageUrl"] =  "http://i2.cdn.turner.com/money/dam/assets/150414182846-high-there-image-1024x576.jpeg"
        articleMedia["type"] = "image"
        articleData["media"] = articleMedia
        articleBaseData["article"] = articleData
        
        articleCard = ArticleCard(title: "The surprising backstory of Tinder for pot smokers", abstractContent: "That's what co-founder Todd Mitchem hopes to create with High There -- \"a social connection app for cannabis consumers.\" Users can look for dates or simply other like-minded people. But for those used to dating apps like Tinder or OkCupid, the questions will probably be a bit unfamiliar.", url: articleURL, creator: cnn, data: articleBaseData)
        
        let summaryData:NSMutableDictionary = NSMutableDictionary()
        let summaryBaseData:NSMutableDictionary = NSMutableDictionary()
        summaryData["subtitle"] = "maxbulger"
        summaryBaseData["summary"] = summaryData
        summaryCardTwitterTweet = SummaryCard(url: NSURL(string: "https://twitter.com/maxbulger/status/590358976023396352")!, description: "We have our fingers in the dike. Hold steady. Keep faving. pic.twitter.com/ndpCXpRSgj", title: "Mɐx Bulger", media: nil, data: summaryBaseData)
        
        
        let summaryDataProfile:NSMutableDictionary = NSMutableDictionary()
        let summaryBaseDataProfile:NSMutableDictionary = NSMutableDictionary()
        summaryDataProfile["subtitle"] = "ryandawidjan"
        summaryBaseDataProfile["summary"] = summaryDataProfile
        
        let profileMedia:NSMutableDictionary = NSMutableDictionary()
        profileMedia["type"] = "image"
        profileMedia["imageUrl"] = "https://pbs.twimg.com/profile_images/580571339779641344/i5gdqaph_400x400.jpg"
        summaryCardTwitterProfile = SummaryCard(url: NSURL(string: "https://twitter.com/ryandawidjan")!, description: "wildcard : menswear : product : biz // connecting with smarter people via 2 wheels and 140 characters.", title: "Ryan", media: profileMedia, data: summaryBaseDataProfile)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layoutLabels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("layoutDemoCell", forIndexPath: indexPath) as! UITableViewCell
        cell.selectionStyle = .None
        cell.textLabel!.text = layoutLabels[indexPath.row]
        cell.detailTextLabel!.text = layoutLabelsSubtexts[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            presentCard(summaryCard, layout: .SummaryCardNoImage, animated: true, completion: nil)
        }else if(indexPath.row == 1){
            presentCard(summaryCard, layout: .SummaryCardTall, animated: true, completion: nil)
        }else if(indexPath.row == 2){
            presentCard(summaryCard, layout: .SummaryCardShort, animated: true, completion: nil)
        }else if(indexPath.row == 3){
            presentCard(summaryCard, layout: .SummaryCardShortLeft, animated: true, completion: nil)
        }else if(indexPath.row == 4){
            presentCard(summaryCard, layout: .SummaryCardImageOnly, animated: true, completion: nil)
        }else if(indexPath.row == 5){
            presentCard(videoCard, layout: .VideoCardShort, animated: true, completion: nil)
        }else if(indexPath.row == 6){
            presentCard(videoCard, layout: .VideoCardShortFull, animated: true, completion: nil)
        }else if(indexPath.row == 7){
            presentCard(videoCard, layout: .VideoCardThumbnail, animated: true, completion: nil)
        }else if(indexPath.row == 8){
            presentCard(imageCard, layout: .ImageCard4x3, animated: true, completion: nil)
        }else if(indexPath.row == 9){
            presentCard(imageCard, layout: .ImageCardAspectFit, animated: true, completion: nil)
        }else if(indexPath.row == 10){
            presentCard(imageCard, layout: .ImageCardImageOnly, animated: true, completion: nil)
        }else if(indexPath.row == 11){
            presentCard(articleCard, layout: .ArticleCardNoImage, animated: true, completion: nil)
        }else if(indexPath.row == 12){
            presentCard(articleCard, layout: .ArticleCardTall, animated: true, completion: nil)
        }else if(indexPath.row == 13){
            presentCard(articleCard, layout: .ArticleCardShort, animated: true, completion: nil)
        }else if(indexPath.row == 14){
            presentCard(summaryCardTwitterTweet, layout:.SummaryCardTwitterTweet, animated:true, completion:nil)
        }else if(indexPath.row == 15){
            presentCard(summaryCardTwitterProfile, layout:.SummaryCardTwitterProfile, animated:true, completion:nil)
        }
    }

}
