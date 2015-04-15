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
    
    var layoutLabels:[String] = ["SummaryCard", "SummaryCard", "SummaryCard", "SummaryCard", "SummaryCard"]
    var layoutLabelsSubtexts:[String] = ["No Image", "Tall", "Short", "Short Left", "Image Only"]
    
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
        }
    }

}
