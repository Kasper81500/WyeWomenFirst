//
//  ViewController.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 27/11/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet var scrollview: UIScrollView!
   
    @IBOutlet var tableview: UITableView!
    
    var imageViewObject :UIImageView!
   
    let url = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/GetAllUserVideolist/")
    
    var indicator:UIActivityIndicatorView!
    
    
    var arrRes = [String]()
    var arrDescription = [String]()
    var arrPath = [String]()
    var datetime = [String]()
    var videosimageslider = [String]()
    var categoryname = [String]()
    var uploadvideoid = [String]()
    var membername = [String]()
    var memberimage = [String]()
    
    
    var imageindex:Int = 1
    let imagewidth:CGFloat = 180
    let imageheight:CGFloat = 122
    
    var xscrollpos:CGFloat = 0
    var scrollviewcontentSize:CGFloat = 0
    var scrollingTimer = NSTimer()
    
    var videoimages = ["bic1.png","bic2.png","bic3.png","bic1.png"]
    var currentCount:Int = 0
    var maxCount:Int = 20
    var uploadProgress:Float = 0
    
    override func viewDidLoad() {
        
       super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
       
        getVideoList()
        
        currentCount = 0
        
        setBackGroundView()
        
        scrollviewAppear()
        
        progressBarView()
        
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    func checkVerifiedUser(){
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let username = prefs.stringForKey("USERNAME") {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as UIViewController
            self.presentViewController(viewController, animated: false, completion: nil)
        }else{
            self.imageViewObject.removeFromSuperview()
        }
    }
    
    func setBackGroundView()
    {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        imageViewObject = UIImageView(frame:CGRectMake(0, 0, screenSize.width, screenSize.height));
        imageViewObject.image = UIImage(named:"bic2")
        imageViewObject.opaque = true
        self.view.addSubview(imageViewObject)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
      
    }
    
    func scrollviewAppear()
    {
        scrollview.layer.cornerRadius = 3
        scrollview.layer.borderColor = UIColor.whiteColor().CGColor
        scrollview.layer.borderWidth = 0.8
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
    
    override func viewDidDisappear(animated: Bool) {
        
        scrollingTimer.invalidate()
    }
    
    
    func newAngle() -> Int {
        return Int(360 * (currentCount / maxCount))
    }
    
    // -------- ------    Show Image Slider using Timer ----------------- //
    
    func showview()
    {
       if(videosimageslider.isEmpty )
       {
       }
       else
       {
            
        for var index=0 ; index<videosimageslider.count ; index++
        {
            if let url = NSURL(string: videosimageslider[index]) {
                if let data = NSData(contentsOfURL: url){
                    if let imageUrl = UIImage(data: data) {
                        
                        let  myimageview:UIImageView = UIImageView()
                        
                        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageUrl: NSURL!) -> Void in
                        }
                        
                        myimageview.sd_setImageWithURL(url, completed: block)
                        
                        myimageview.frame.size.width = imagewidth
                        myimageview.frame.size.height = imageheight
                        myimageview.contentMode = UIViewContentMode.ScaleToFill
                        myimageview.frame.origin.x = xscrollpos
                        myimageview.frame.origin.y = 5
                        
                        scrollview!.addSubview(myimageview)
                        
                        xscrollpos += imagewidth
                        
                        scrollviewcontentSize += imagewidth
                        
                        scrollview.contentSize = CGSize(width: scrollviewcontentSize, height: imageheight)
                    }
                }
            }            
        }
       
        scrollingTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "newStartScrolling", userInfo: nil, repeats: true)
        
        scrollingTimer.fire()
        
        }
    }
    
    func newStartScrolling()
    {
        var currentOffset = scrollview.contentOffset
        currentOffset = CGPointMake(currentOffset.x+2, currentOffset.y)
        
        if(currentOffset.x < scrollview.contentSize.width - 500)
        {
            scrollview.setContentOffset(currentOffset, animated: false)
            currentOffset = CGPointMake(0, currentOffset.y )
            
           //scrollview.contentSize = CGSize(width: 0, height: 0);
        }
        else
        {
            scrollingTimer.invalidate()
            showview()
        }
    }
    
    // -----  get list ------ //
    func getVideoList()
    {
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/GetAllUserVideolist/")
        let URLRequest = NSMutableURLRequest(URL: url!)
        URLRequest.cachePolicy = .ReturnCacheDataElseLoad
        URLRequest.timeoutInterval = 100
        
        Alamofire.request(.POST, URLRequest, encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    self.displayMessage("Some Network Issue")
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["GetAllUserVideolistResult"]
                    let results2 = results["ObjVideoThumbList"]
                  
                    for (_, object) in results2 {
                        
                     let videolistthumb = object["videoimage"].stringValue
                
                     self.videosimageslider.append(videolistthumb)
                        
                    }
                    
                    let results3 = results["objvideocategory"]
                    
                    for (_, object) in results3 {
                        
                        let categoryname =  object["Category"].stringValue
                        let videolist = object["objResult"]
                        
                        for (_, object) in videolist {
                            
                            let description = object["Description"].stringValue
                            let heading =  object["Heading"].stringValue
                            let uploadfile = object["UploadFileID"].stringValue
                            let uploaddate =  object["uploadededDate"].stringValue
                            let videothumb =  object["videoThumb"].stringValue
                            let membername = object["MemberName"].stringValue
                            let memberimage = object["MemberImage"].stringValue

                            self.arrRes.append(heading)
                            self.arrDescription.append(description)
                            self.arrPath.append(videothumb)
                            self.datetime.append(uploaddate)
                            self.uploadvideoid.append(uploadfile)
                            self.categoryname.append(categoryname)
                            self.membername.append(membername)
                            self.memberimage.append(memberimage)
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableview.reloadData()
                        self.showview()
                        self.indicator.stopAnimating()
                        self.indicator.willRemoveSubview(self.indicator)
                        self.checkVerifiedUser()
                    }
                }
        }
    }
    
    // ---------------------------- Message Display ---------------------------- //
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

    
    
    
    
    
    
     // --------------------------Gradient Color-------------------------------- //
    
    
    func gradientColor()
    {
        
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1).CGColor
        let color2 = UIColor(red: 0/255.0, green:0/255.0, blue:0/255.0, alpha:1).CGColor
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0,  1.2]
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
     
        
        
    }
    

    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as! CustomTableViewcell
        
        cell.titlevalue.text = arrRes[indexPath.row]
        cell.descriptionvalue.text = arrDescription[indexPath.row]
        cell.date.text = datetime[indexPath.row]
        cell.videocategory.text = categoryname[indexPath.row]
        cell.membername.text = membername[indexPath.row]
        
       // cell.layer.shouldRasterize = true
        cell.cellview.layer.cornerRadius = 3
        cell.cellview.layer.borderColor = UIColor.grayColor().CGColor
        cell.cellview.layer.borderWidth = 0.5
        
        if let url = NSURL(string: memberimage[indexPath.row]) {
            
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                //			println(self)
            }
            
           cell.memberimage.sd_setImageWithURL(url, completed: block)
            
           cell.memberimage.layer.borderWidth = 1.0
           cell.memberimage.layer.masksToBounds = false
           cell.memberimage.layer.borderColor = UIColor.grayColor().CGColor
           cell.memberimage.layer.cornerRadius = cell.memberimage.frame.width / 2
           cell.memberimage.clipsToBounds = true
        }
        
        if let url = NSURL(string: arrPath[indexPath.row]) {
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                //			println(self)
            }
            
            cell.imagepath.sd_setImageWithURL(url, completed: block)
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       // print(self.arrRes.count)
        return self.arrRes.count

    }

     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 155
    }
    
}

