//
//  VideosViewController.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 27/11/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import ionicons

class VideosViewController:UITableViewController , UISearchResultsUpdating
{
    
    
    var indicator:UIActivityIndicatorView!
    
    var arrRes = [String]()
    var arrDescription = [String]()
    var arrPath = [String]()
    var datetime = [String]()
    var categoryname = [String]()
    var uploadedFile = [String]()
    var videofilepath = [String]()
    
    var whiteRoundedView : UIView!
    var filteredTableData = [String]()
    //var resultSearchController = UISearchController()
    
    
    
    var membername = [String]()
    var memberimage = [String]()
   

    @IBOutlet var searchview: UISearchBar!
    @IBOutlet var backbtn: UIBarButtonItem!
    @IBOutlet var tableview: UITableView!
    
    var cell:UITableViewCell?
    
    var pageIndex : Int = 1
    var isMoreVideoAvailable : Bool = true;
    var isDownloadingVideo : Bool = false;
    
    
    override func viewDidLoad() {
        
        getList()
        
        backbtn.target = self.revealViewController()
        backbtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        backbtn.image = IonIcons.imageWithIcon(ion_navicon_round, iconColor: UIColor.darkGrayColor(), iconSize: 30, imageSize: CGSize(width: 30, height: 30))
        
//        resultSearchController = UISearchController(searchResultsController: nil)
//        resultSearchController.searchResultsUpdater = self
//        resultSearchController.dimsBackgroundDuringPresentation = false
//        resultSearchController.searchBar.placeholder = "Search here..."
//        resultSearchController.hidesNavigationBarDuringPresentation = false
//        
//        // Place the search bar view to the tableview headerview.
//        tableview.tableHeaderView = resultSearchController.searchBar
        
        
       progressBarView()
    }
    
    func progressBarView()
    {
        indicator  = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.color = UIColor .blackColor()
        indicator.frame = CGRectMake(0.0, 0.0, 60.0, 60.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
       var cell = tableview.dequeueReusableCellWithIdentifier("CellVideo") as? VideoCell
        
        
        if(cell == nil)
        {
          
         //   let nib = UINib(nibName: "VideoCell", bundle: nil)
           // tableview.registerNib(nib, forCellReuseIdentifier: "CellVideo")
            
            tableview.registerNib(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "CellVideo")
            cell = VideoCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CellVideo")
            cell = tableview.dequeueReusableCellWithIdentifier("CellVideo") as? VideoCell
            
           // cell?.selectionStyle = UITableViewCellSelectionStyle.None;
            
            
        }
        
        
//        if (self.resultSearchController.active) {
//          //  print("result for Search  ")
//            cell!.videoname.text = arrRes[indexPath.row]
//            cell!.videodesc.text = arrDescription[indexPath.row]
//            cell!.videodate.text = datetime[indexPath.row]
//            cell!.categoryname.text = filteredTableData[indexPath.row]
//            cell!.membername.text = membername[indexPath.row]
//        }
//            
//        else
//        {
            print(" result all ")
            cell!.videoname.text = arrRes[indexPath.row]
            cell!.videodesc.text = arrDescription[indexPath.row]
            cell!.videodate.text = datetime[indexPath.row]
            cell!.categoryname.text = categoryname[indexPath.row]
            cell!.membername.text = membername[indexPath.row]
//        }
        
        
        cell!.videodesc.textColor = UIColorFromHex(0x8f8f8f,alpha:1)
        cell!.videodate.textColor = UIColorFromHex(0x8f8f8f,alpha:1)
        cell!.cellview.layer.cornerRadius = 3
        cell!.cellview.layer.borderColor = UIColor.grayColor().CGColor
        cell!.cellview.layer.borderWidth = 0.5
        
        if let url = NSURL(string: memberimage[indexPath.row]) {
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                //			println(self)
            }
            
            
            cell?.memberimage.sd_setImageWithURL(url, completed: block)
            
            cell!.memberimage.layer.borderWidth = 1.0
            cell!.memberimage.layer.masksToBounds = false
            cell!.memberimage.layer.borderColor = UIColor.grayColor().CGColor
            cell!.memberimage.layer.cornerRadius = cell!.memberimage.frame.width / 2
            cell!.memberimage.clipsToBounds = true
        }
        
        if let url = NSURL(string: arrPath[indexPath.row]) {
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                //			println(self)
            }
            
            // let url = NSURL(string: "http://yikaobang-test.u.qiniudn.com/FnZTPYbldNXZi7cQ5EJHmKkRDTkj")
            
            
            cell!.imagevideo.sd_setImageWithURL(url, completed: block)
        }
        
        return cell!
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 160
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if (self.resultSearchController.active) {
//            return self.filteredTableData.count
//        }
//        else {
            return self.arrRes.count
//        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableview.separatorColor = UIColor.clearColor()
        
        if(indexPath.row == self.arrRes.count - 1){
            getMoreList();
        }
    }

    
    func  updateSearchResultsForSearchController(searchController: UISearchController) {
        
        self.filteredTableData.removeAll(keepCapacity: false)
        let searchpredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let  array = (self.categoryname as NSArray).filteredArrayUsingPredicate(searchpredicate)
        self.filteredTableData = array as! [String]
        self.tableview.reloadData()
    }

    
    func displayMessage(message:String)
    {
        let alertController = UIAlertController(title: "Message Alert", message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
          //  print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
           // print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }

    
    func getList()
    {
      
        //let url = NSURL(string:"http://applehotelbooking.com/webapi/Service1.svc/GetAllUserVideolist/")
        
          let url = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/GetAllUserVideolist/200/1")
        
       //  let url = NSURL(string:"http://service.womenwomenfirst.com/Service1.svc/GetAllUserVideolist/")
         // print(url)
        
        
        let URLRequest = NSMutableURLRequest(URL: url!)
        URLRequest.cachePolicy = .ReturnCacheDataElseLoad
        URLRequest.timeoutInterval = 100        
        
        Alamofire.request(.POST, URLRequest,  encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    // self.displayMessage(String(response.result.error))
                    self.displayMessage("Some Network Issue")
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    // print(swiftyJsonVar)
                    
                    
                    let results = swiftyJsonVar["GetAllUserVideolistResult"]
                    
                    // print(results)
                    
                    
                    // print(results)
                    //  print(swiftyJsonVar.count)
                    //    print("-------results1------")
                    
                    //   let results1 = results["Message"].stringValue
                    //   print("object results ")
                    //   print(results1)
                    
                    // self.categoryname.text = results1
                    
                    let results2 = results["objvideocategory"]
                    // print("category")
                    //  print(results2)
                    
                    
                    for (_, object) in results2 {
                        
                        let categoryname =  object["Category"].stringValue
                        let videolist = object["objResult"]
                        
                        
                        for (_, object) in videolist {
                            
                            let description = object["Description"].stringValue
                            let heading =  object["Heading"].stringValue
                            let uploadfile = object["UploadFileID"].stringValue
                            let uploaddate =  object["uploadededDate"].stringValue
                            
                           // let memberid = object["MemberID"].stringValue
                            let videothumb =  object["videoThumb"].stringValue
                            let videofilepath = object["FilePath"].stringValue
                            
                      //      print("upload file ")
                         //   print(uploadfile)
                         //   print("member id ")
                         //  print(memberid)
                            
                            
                            let membername = object["MemberName"].stringValue
                            
                            //  print(membername)
                            
                            let memberimage = object["MemberImage"].stringValue
                            
                            // print(memberimage)
                            
                            self.arrRes.append(heading)
                            self.arrDescription.append(description)
                            self.arrPath.append(videothumb)
                            self.datetime.append(uploaddate)
                            self.categoryname.append(categoryname)
                            self.uploadedFile.append(uploadfile)
                            self.videofilepath.append(videofilepath)
                            self.membername.append(membername)
                            self.memberimage.append(memberimage)
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableview.reloadData()
                            self.indicator.stopAnimating()
                            self.indicator.willRemoveSubview(self.indicator)
                        }
                        
                    }
                }
        }
    }
    func getMoreList()
    {
        if !isMoreVideoAvailable || isDownloadingVideo {
            return;
        }
        
        isDownloadingVideo = true
        
        pageIndex += 1
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/GetAllUserVideolist/200/" + String(pageIndex))
        let URLRequest = NSMutableURLRequest(URL: url!)

        URLRequest.cachePolicy = .ReturnCacheDataElseLoad
        URLRequest.timeoutInterval = 100
        
        Alamofire.request(.POST, URLRequest,  encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    self.displayMessage("Some Network Issue")
                    self.isDownloadingVideo = false
                    return
                }
                
                self.isDownloadingVideo = false
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    
                    let results = swiftyJsonVar["GetAllUserVideolistResult"]
                    
                    let messageType = results["Message"].stringValue
                   
                    if messageType == "novideo" {
                        self.isMoreVideoAvailable = false
                    
                    }else{
                        let results2 = results["objvideocategory"]
                    
                        for (_, object) in results2 {
                            
                            let categoryname =  object["Category"].stringValue
                            let videolist = object["objResult"]
                            
                            
                            for (_, object) in videolist {
                                
                                let description = object["Description"].stringValue
                                let heading =  object["Heading"].stringValue
                                let uploadfile = object["UploadFileID"].stringValue
                                let uploaddate =  object["uploadededDate"].stringValue
                                
                                let videothumb =  object["videoThumb"].stringValue
                                let videofilepath = object["FilePath"].stringValue
                                
                                let membername = object["MemberName"].stringValue
                                
                                let memberimage = object["MemberImage"].stringValue
                                
                                self.arrRes.append(heading)
                                self.arrDescription.append(description)
                                self.arrPath.append(videothumb)
                                self.datetime.append(uploaddate)
                                self.categoryname.append(categoryname)
                                self.uploadedFile.append(uploadfile)
                                self.videofilepath.append(videofilepath)
                                self.membername.append(membername)
                                self.memberimage.append(memberimage)
                            }
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableview.reloadData()
                                self.indicator.stopAnimating()
                                self.indicator.willRemoveSubview(self.indicator)
                            }
                            
                        }
                    }
                }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
      //  print("____________________________________________")
       // print("prepare for segue ......")
      ///   print("____________________________________________")
        
        
        if( segue.identifier=="videoselectall")
        {
            
            let destination : VideoPlayController = segue.destinationViewController as!  VideoPlayController
            
            let indexPathval = self.tableview.indexPathForSelectedRow!
            
        //   print("Click on segue ")
        //   print("++++++++++++++++++++++++++++++++++")
         //  print(uploadedFile[indexPathval.row])
        //   print("++++++++++++++++++++++++++++++++++")
            destination.titlefinalvalue = uploadedFile[indexPathval.row]            
            
        }
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}