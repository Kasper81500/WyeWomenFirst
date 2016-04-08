//
//  RssFeed.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 03/12/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import Foundation
import UIKit
import ionicons

class RssFeed : UIViewController , MWFeedParserDelegate
{
    
    
    @IBOutlet var homebtn: UIBarButtonItem!
    
    @IBOutlet var tableview: UITableView!
    
    var feedItems = [MWFeedItem]()
    
    
    func requestData()
    {
        let url = NSURL(string: "http://www.nytimes.com/services/xml/rss/nyt/Education.xml")
        
        let feedparser = MWFeedParser(feedURL: url)
        
        feedparser.delegate = self
        
        feedparser.parse()
        
    }
    
    
    
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        
        print(info)
        self.title = info.title
        
        
        
    }
    
    func feedParserDidStart(parser: MWFeedParser!) {
        
        feedItems = [MWFeedItem]()
        
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        
        
        self.tableview.reloadData()
        
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        
        feedItems.append(item)
        
        
    }
    
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedItems.count
        
        
    }
    
   func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = feedItems[indexPath.row] as MWFeedItem
        
        print(item)
    }
    
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Rsscell", forIndexPath: indexPath) as UITableViewCell
        
        let item = feedItems[indexPath.row] as MWFeedItem
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = UIColor.grayColor()
    
        return cell
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        requestData()
        
        self.tableview.rowHeight = 100
        
         self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        
        homebtn.target = self.revealViewController()
        homebtn.action = Selector("revealToggle:")
        homebtn.image = IonIcons.imageWithIcon(ion_navicon_round, iconColor: UIColor.darkGrayColor(), iconSize: 30, imageSize: CGSize(width: 30, height: 30))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
    
    
}