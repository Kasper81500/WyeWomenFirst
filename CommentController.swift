//
//  CommentController.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 01/12/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class CommentController:UIViewController
{
    
    let url = NSURL(string:"http://applehotelbooking.com/webapi/Service1.svc/PostComment/1/1/reloadme")
    
 
    
    
    var commentsegue :String = ""
    
    
    
    
    @IBOutlet var commentBtn: UIButton!
  
    
    @IBOutlet var commentTxt: UITextField!
    
    @IBAction func sendData(sender: AnyObject) {
        
        loadVideoList()
    }
    
    
    override func viewDidLoad() {
        
        commentBtn.layer.borderWidth = 2
        
     
       // commentBtn.layer.backgroundColor = UIColorFromHex(0x0d7ab5,alpha:0.8).CGColor
        commentBtn.layer.cornerRadius = 16.0
        
        
        commentTxt.layer.borderWidth = 2
        
        
        commentTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8).CGColor
        commentTxt.layer.cornerRadius = 10.0
        

        
        
        
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        
        let color1 = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1).CGColor
        let color2 = UIColor(red: 154/255.0, green:154/255.0, blue:154/255.0, alpha:1).CGColor
        
        
        
        //  let color1 = UIColor(rgba: "##8968CD").CGColor
        // let color2 = UIColor(rgba: "#5D478B").CGColor
        
        
        // gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        // gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        
        gradientLayer.colors = [color1, color2]
        
        
        // 4
        gradientLayer.locations = [0.0,  1.2]
        
        // 5
        
        self.view.layer.addSublayer(gradientLayer)
        
        
       print(commentsegue)
        
        
        
    }
    
    
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    

    
    func loadVideoList()
    {
        
        
        print("Send data ")
        
        Alamofire.request(.POST, url!).responseJSON { (responseData) -> Void in
            let swiftyJsonVar = JSON(responseData.result.value!)
            
            print(swiftyJsonVar)
            print("-------------")
            let results = swiftyJsonVar["PostCommentResult"]
            
                 print(results)
            
            
            /*
            for (_, object) in results1 {
                
                let name = object["Heading"].stringValue
                let description = object["Description"].stringValue
                let path = object["ThumbPath"].stringValue
                let datetime = object["uploadededDate"].stringValue
                
                
                print("path")
                print(path)
                
                
            }
*/
            dispatch_async(dispatch_get_main_queue()) {
              //  self.tableview.reloadData()
            }
            
        }
        
        
    }
    
    

    
    
    
    
    
}