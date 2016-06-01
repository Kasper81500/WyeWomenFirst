//
//  UserProfileViewController.swift
//  WomenWomenFirst
//
//  Created by HotStar on 5/4/16.
//  Copyright © 2016 blitzinfosystem. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import MediaPlayer

import AVKit
import AVFoundation

import MobileCoreServices
import ionicons
class UserProfileViewController :UIViewController
{
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userSurname: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var userPhoneNumber: UILabel!
    
    @IBOutlet weak var userCity: UILabel!
    
    @IBOutlet weak var userPhotoImg: UIImageView!
    
    @IBOutlet weak var userCounty: UILabel!
        
    @IBOutlet weak var userDistrict: UILabel!
    
    @IBOutlet weak var userCountry: UILabel!
    
    @IBOutlet weak var userTerritory: UILabel!
    
    var memberId :String = ""
    var urlVideo :NSURL = NSURL()
    var namevalue :String = ""
    var surnamevalue:String = ""
    var emailvalue:String = ""
    var cityvalue :String = ""
    var countyvalue:String = ""
    var countryvalue:String = ""
    var districtvalue :String = ""
    var territoryvalue:String = ""
    var candidatevalue:String = ""
    var phonevalue:String = ""
    var indicator:UIActivityIndicatorView!
    var imagepic:String = ""
    
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        userName.text = ""
        userSurname.text = ""
        userEmail.text = ""
        userPhoneNumber.text = ""
        userCity.text = ""
        userCounty.text = ""
        userDistrict.text = ""
        userCountry.text = ""
        userTerritory.text = ""
        userName.text = ""
        
        gradientColor()
        progressBarView()
        
        getList(memberId)
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
    
    func gradientColor()
    {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1).CGColor
        let color2 = UIColor(red: 128/255.0, green:128/255.0, blue:128/255.0, alpha:1).CGColor
        
        gradientLayer.colors = [color1, color2]
        
        // 4
        gradientLayer.locations = [0.0,  5.0]
        
        // 5
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func getList(memberid:String)
    {
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/service1.svc/GetMember/"+memberid)
        
        Alamofire.request(.POST, url!,  encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    // self.displayMessage(String(response.result.error))
                    // self.displayMessage("Some Network Issue")
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    
                    let results = swiftyJsonVar["GetMemberResult"]
                    let results2 = results["Candidate"].stringValue
                    let results4 = results["Email"].stringValue
                    let results5 = results["Name"].stringValue
                    let results6 = results["SurName"].stringValue
                    let results7 = results["City"].stringValue
                    let results8 = results["County"].stringValue
                    let results9 = results["District"].stringValue
                    let results10 = results["Country"].stringValue
                    let results11 = results["Terroritry"].stringValue
                    let resutls12 = results["userImage"].stringValue
                    let results13 = results["Phone"].stringValue
                    
                    self.imagepic = resutls12
                    self.namevalue = results5
                    self.surnamevalue = results6
                    self.emailvalue = results4
                    self.cityvalue = results7
                    self.countryvalue = results10
                    self.districtvalue = results9
                    self.countyvalue = results8
                    self.territoryvalue = results11
                    self.candidatevalue = results2
                    self.phonevalue = results13
                    
                }
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.userName.text = self.namevalue
                    self.userSurname.text = self.surnamevalue
                    self.userEmail.text = self.emailvalue
                    self.userCity.text = self.cityvalue
                    self.userPhoneNumber.text = self.phonevalue
                    self.userCounty.text = self.countyvalue
                    self.userDistrict.text = self.districtvalue
                    self.userCountry.text = self.countryvalue
                    self.userTerritory.text = self.territoryvalue
                    
                    self.indicator.stopAnimating()
                    self.indicator.willRemoveSubview(self.indicator)
                    
                    let url = NSURL(string: self.imagepic)
                    
                    let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                    }
                    
                    self.userPhotoImg.sd_setImageWithURL(url, completed: block)
                    
                }
                
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier=="UserVideo")
        {
            let destination : UserVideosController = segue.destinationViewController as!  UserVideosController
            destination.memberId = memberId
        }
    }

}