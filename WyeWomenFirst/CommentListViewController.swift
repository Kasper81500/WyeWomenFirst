//
//  CommentListViewController.swift
//  WomenWomenFirst
//
//  Created by HotStar on 5/31/16.
//  Copyright © 2016 blitzinfosystem. All rights reserved.
//

import Foundation
//
//  VideoPlayController.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 30/11/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit
import AVKit
import AVFoundation
import Alamofire
import SwiftyJSON
import MobileCoreServices

class CommentListViewController:UIViewController , UITableViewDelegate , UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate
{
    var cell : UITableViewCell?
    
    var comments : String = ""
    
    var titlefinalvalue:String = ""
    
    var customView:UITextView!
    
    var arrComment = [String]()
    var arrCommentBy = [String]()
    var arrCommentdate = [String]()
    var arrCommentId = [String]()
    
    var commentimage = [String]()
    
    var usercompletename:String = ""
    var videourl:String = ""
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var tableview: UITableView!
    
    var finalmemberid:String = ""
    
    var  filenamedownload:String = ""
    
    var   tap: UITapGestureRecognizer!
    
    var youtubeURL:String = "https://www.youtube.com/embed/b9PE22dBk5E"
    var videotype:String = ""
    
    override func viewDidLoad() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey("USERNAME")
        {
            print(name)
        }
        
        if let memberid = defaults.stringForKey("MEMBERID")
        {
            finalmemberid = memberid
        }
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
        
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        //tableview is your UITAbleView in UIViewController
        self.tableview.addSubview(refreshControl)
        
        getList()
        
        tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Comment", style: UIBarButtonItemStyle.Plain, target: self, action: "commentSend"), animated: true)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func refreshData()
    {
        getList()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as? CommentVideoCell
        
        if (indexPath.row < arrCommentId.count) {
            cell!.comment.text  = arrCommentBy[indexPath.row]
            cell!.commentperson.text  = arrComment[indexPath.row]
            cell!.commentdate.text = arrCommentdate[indexPath.row]
            
            cell!.cellview.layer.cornerRadius = 3
            cell!.cellview.layer.borderColor = UIColor.grayColor().CGColor
            cell!.cellview.layer.borderWidth = 0.5
            
            if let url = NSURL(string: commentimage[indexPath.row]) {
                
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                    //			println(self)
                }
                
                cell!.commetedpic.sd_setImageWithURL(url, completed: block)
                cell!.commetedpic.layer.borderWidth = 1.0
                cell!.commetedpic.layer.masksToBounds = false
                cell!.commetedpic.layer.borderColor = UIColor.grayColor().CGColor
                cell!.commetedpic.layer.cornerRadius = cell!.commetedpic.frame.width / 2
                cell!.commetedpic.clipsToBounds = true
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrComment.count
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func getList()
    {
        if(titlefinalvalue.isEmpty)
        {
            return;
        }
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/GetUploadedVideoData/"+titlefinalvalue)
        
        let URLRequest = NSMutableURLRequest(URL: url!)
        URLRequest.cachePolicy = .ReturnCacheDataElseLoad
        URLRequest.timeoutInterval = 100
        
        print("Destination url ")
        print(url)
        
        Alamofire.request(.POST, URLRequest,  encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    // self.displayMessage(String(response.result.error))
                    //  self.displayMessage("Some Network Issue")
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["GetUploadedVideoDataResult"]
                    let results1 = results["CommentResult"]
                    let results3 = results["FilePath"].stringValue
                    let results4 = results["Urltype"].stringValue
                    let results5 = results["Despcription"].stringValue
                    let results6 = results["Name"].stringValue
                    let results7 = results ["SurName"].stringValue
                    
                    self.usercompletename = "\(results6) \(results7)"
                    
                    self.videotype = results4
                    
                    if !results3.isEmpty {
                        self.youtubeURL = results3.stringByReplacingOccurrencesOfString("https://www.youtube.com/watch?v=", withString: "https://www.youtube.com/embed/")
                    }
                    
                    print("File path url0000000000000000 "+results3);
                    
                    print("***************************")
                    print(self.usercompletename)
                    print("****************************")
                    
                    self.navigationController?.title = self.usercompletename
                    
                    self.videourl = results3
                    
                    for (_, object) in results1 {
                        
                        let commentby = object["CommentBy"].stringValue
                        let commentdate = object["CommentDate"].stringValue
                        let commenttext = object["Commenttext"].stringValue
                        let commentid = object["CoomentID"].stringValue
                        let commentedpic = object["CommentUserImage"].stringValue
                        
                        print(commentedpic)
                        
                        self.arrCommentBy.append(commentby)
                        self.arrCommentdate.append(commentdate)
                        self.arrComment.append(commenttext)
                        self.arrCommentId.append(commentid)
                        
                        self.commentimage.append(commentedpic)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        if self.refreshControl.refreshing
                        {
                            self.refreshControl.endRefreshing()
                        }
                        
                        self.tableview.reloadData()
                    }
                }
        }
    }
    
    func commentSend() {
        
        //     print("asfdsfasdffds")
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        // let margin:CGFloat = 8.0
        let rect = CGRectMake(10, 10, 250 ,250)
        customView = UITextView(frame: rect)
        
        customView!.delegate = self
        customView.backgroundColor = UIColor.clearColor()
        customView.font = UIFont(name: "Helvetica", size: 20)
        
        alertController.view.addSubview(customView)
        
        let somethingAction = UIAlertAction(title: "Comment ", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in print("something")
            
            print(self.customView.text)
            
            if( self.customView.text.isEmpty)
            {
                return
            }
            
            self.comments = self.customView.text
            
            let newString = self.comments.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            let finalcomment:String = newString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            
            let urlcomment = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/PostComment/"+self.finalmemberid+"/"+self.titlefinalvalue+"/"+finalcomment)
            
            Alamofire.request(.POST, urlcomment!).responseJSON { (responseData) -> Void in
//                
//                let swiftyJsonVar = JSON(responseData.result.value!)
//                
//                let results = swiftyJsonVar["PostCommentResult"]
//                
                dispatch_async(dispatch_get_main_queue()) {
                    self.commentDataReloading()
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:{})
    }
    
    func commentDataReloading(){
        self.arrCommentBy.removeAll()
        self.arrCommentdate.removeAll()
        self.arrComment.removeAll()
        self.arrCommentId.removeAll()
        self.commentimage.removeAll()
        self.getList()
    }
    
    func textView(customView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = (customView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 128;
    }
    
    func textViewDidChange(customView: UITextView) { //Handle the text changes here
        //  print(customView.text); //the textView parameter is the textView where text was changed
    }
    
    func textFieldShouldReturn(customView: UITextView) -> Bool {   //delegate method
        
        customView.resignFirstResponder()
        
        return true
    }
    
    func displayMessage(message:String)
    {
        let alertController = UIAlertController(title: "Message Alert", message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
}