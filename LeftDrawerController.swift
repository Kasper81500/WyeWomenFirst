//
//  LeftDrawerController.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 27/11/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import Foundation
import UIKit
class LeftDrawerController : UIViewController ,UITableViewDataSource , UITableViewDelegate
{
    var tabledata = [String]()
    var tabledatanew = [String]()
    
    @IBOutlet var username: UILabel!

    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var logout: UIButton!
    
    @IBOutlet var imageuser: UIImageView!
    
    var headingname:String?
    
    override func viewDidLoad() {
        
        tabledatanew = ["Videos","MyVideos","UploadVideos","RssFeed","Editprofile","UploadYoutube"]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let name = defaults.stringForKey("USERNAME")
        {
            username.text = name
        }
        
        if let memberid = defaults.stringForKey("MEMBERID")
        {
            print("Member id  in left drawer ")
            print(memberid)
        }

        if let memberimage = defaults.stringForKey("USERIMAGE")
        {
            let url = NSURL(string: memberimage)
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
            }
            
            imageuser.sd_setImageWithURL(url, completed: block)
            imageuser.layer.borderWidth = 2.0
            imageuser.layer.masksToBounds = false
            imageuser.layer.borderColor = UIColor.whiteColor().CGColor
            imageuser.layer.cornerRadius = imageuser.frame.width / 2
            imageuser.clipsToBounds = true
        }

        //tableview.backgroundColor = UIColorFromHex(0x6e7173,alpha:1)
      
        self.tableview.rowHeight = 60
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tabledatanew.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCellWithIdentifier(tabledatanew[indexPath.row], forIndexPath: indexPath)
        
        if indexPath.row == 0 {
            tableview.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        }
        return cell
    }
    
    @IBAction func logoutUser(sender: AnyObject) {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("Hello", forKey: "phone")
        let phone = defaults.objectForKey("USERNAME") as! String
        // This will save your value in `phone`
        // Do not synchronize after removing the key, if you want 'value' for your key 'phone' after your application terminated
        defaults.synchronize()
        print(phone)
        defaults.removeObjectForKey("USERNAME")
        
        // Get the updated value,
        let updatedPhone = defaults.objectForKey("USERNAME") as! String?
        // This will save nil in your `phone` key, make sure that what you want
        defaults.synchronize() 
        print("phone2\(updatedPhone)")
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ScreenScroll") as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}