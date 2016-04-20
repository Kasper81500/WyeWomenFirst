//
//  MyVideosController.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 27/11/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import ionicons


class MyVideosController:UITableViewController
{
    
    @IBOutlet var homebtn: UIBarButtonItem!
     var indicator:UIActivityIndicatorView!
    
    @IBOutlet var tableview: UITableView!
    
    var arrRes = [String]()
    var arrDescription = [String]()
    var arrPath = [String]()
    var uploadvideoid = [String]()
    var datetime = [String]()
    
    var categoryname = [String]()
    var videofilepath = [String]()
    
    var Userid:String = ""
    
    
    override func viewDidLoad() {
                print("This is  MyVideo view Controller ")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        homebtn.target = self.revealViewController()
        homebtn.action = Selector("revealToggle:")
        
        homebtn.image = IonIcons.imageWithIcon(ion_navicon_round, iconColor: UIColor.darkGrayColor(), iconSize: 30, imageSize: CGSize(width: 30, height: 30))
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey("USERNAME")
        {
            
            print("user name   in myvideo controlleer drawer ")
            
            print(name)
                  }
        
        if let memberid = defaults.stringForKey("MEMBERID")
        {
            
            print("Member id  in my video controller  ")
           
            getList(memberid)

         
        }
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyVideoCell", forIndexPath:indexPath) as! MyVideosCell
        
        cell.myvideostitle.text = arrRes[indexPath.row]
        cell.myvideosdesc.text = arrDescription[indexPath.row]
        cell.myvideosdate.text = datetime[indexPath.row]
        cell.categoryname.text = categoryname[indexPath.row]
        
        cell.cellview.layer.cornerRadius = 3
        cell.cellview.layer.borderColor = UIColor.grayColor().CGColor
        cell.cellview.layer.borderWidth = 0.5
        
        if let url = NSURL(string: arrPath[indexPath.row]) {
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                //			println(self)
            }
            
            // let url = NSURL(string: "http://yikaobang-test.u.qiniudn.com/FnZTPYbldNXZi7cQ5EJHmKkRDTkj")
            
            cell.myvideosimage.sd_setImageWithURL(url, completed: block)
            
            /*
            if let data = NSData(contentsOfURL: url) {
                cell.myvideosimage.image = UIImage(data: data)
            }
            */
            
        }
        
        return cell
        
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 150
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(self.arrRes.count)
        return self.arrRes.count
        
    }
    
    func getList(memberid:String)
    {
        
       // let url = NSURL(string:"http://applehotelbooking.com/webapi/Service1.svc/GetUserVideolist/"+memberid)
        
       
         let url = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/GetUserVideolist/"+memberid)
        
       // let url = NSURL(string:"http://service.womenwomenfirst.com/Service1.svc/GetUserVideolist/"+memberid)
        

        
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
                    
                    self.indicator.stopAnimating()
                    self.indicator.willRemoveSubview(self.indicator)

                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    // print(swiftyJsonVar)
                    
                    
                   let results = swiftyJsonVar["GetUserVideolistResult"]
                    
                   let results1 = results["Message"].stringValue
                   print("object results ")
                   print(results1)
                    
                    if(results1 == "novideo")
                    {
                        self.indicator.stopAnimating()
                        self.indicator.willRemoveSubview(self.indicator)

                        let alertController = UIAlertController(title: "My Videos!", message: "Sorry no Videos yet Please upload first", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)

                    }
                    
                    
                    // self.categoryname.text = results1
                    
                    
                    
                    let results2 = results["objvideocategory"]
                    // print("category")
                    //  print(results2)
                    
                    
                    
                    
                    for (_, object) in results2 {
                        
                        let categoryname =  object["Category"].stringValue
                        let videolist = object["objResult"]
                        
                        
                        for (_, object) in videolist {
                            
                            let description = object["Description"].stringValue.stringByRemovingPercentEncoding!
                            let heading =  object["Heading"].stringValue
                            let uploadfile = object["UploadFileID"].stringValue
                            let uploaddate =  object["uploadededDate"].stringValue
                            
                           // let memberid = object["MemberID"].stringValue
                            let videothumb =  object["videoThumb"].stringValue
                            
                            
                            let videofilepathstring = object["FilePath"].stringValue
                            
                            
                         //   print("upload file ")
                         //   print(uploadfile)
                        //    print("member id ")
                        //    print(memberid)
                            
                            
                            self.arrRes.append(heading)
                            self.arrDescription.append(description)
                            self.arrPath.append(videothumb)
                            self.datetime.append(uploaddate)
                            self.uploadvideoid.append(uploadfile)
                            self.categoryname.append(categoryname)
                            self.videofilepath.append(videofilepathstring)
                            
                            
                            
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier=="videoselect")
        {
        
        let destination : VideoPlayController = segue.destinationViewController as!  VideoPlayController
          
        let indexPathval = self.tableview.indexPathForSelectedRow!
            
         //   print("Click on segue ")
        //    print("++++++++++++++++++++++++++++++++++")
            print(uploadvideoid[indexPathval.row])
            print(videofilepath[indexPathval.row])
            
         //   print("++++++++++++++++++++++++++++++++++")
              destination.titlefinalvalue = uploadvideoid[indexPathval.row]
             destination.filenamedownload = videofilepath[indexPathval.row]
            
        }
        
    }

    
  
    
}