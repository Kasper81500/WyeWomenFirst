//
//  UploadVideoYoutube.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 11/01/16.
//  Copyright © 2016 blitzinfosystem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ionicons


class UploadVideoYoutube:UIViewController, UITextViewDelegate{
    
    
    @IBOutlet var homebtn: UIBarButtonItem!
   
    
    @IBOutlet var youtubelink: UITextField!
    
    
    @IBOutlet var uploadbtn: UIButton!
    
    
    @IBOutlet var youtubedes: UITextView!
    
    
    var filename : String = ""
    var filedesc : String = ""
    var category : String = ""
    var urlVideo :NSURL = NSURL()
     var memberidvideo : String = ""
    
    var headingval:String = ""
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func sendUrl(sender: AnyObject) {
        
         let url = NSURL(string:"http://www.womenwomenfirst.com/service/FileUploadService.svc/UploadFileUrl/")
        
        headingval = "Youtubefile"
        category = "Youtube"
        filedesc = youtubedes.text
        filename = "Youtube"
        
        let stringWithPossibleURL: String = self.youtubelink.text! // Or another source of text
        
        if let validURL: NSURL = NSURL(string: stringWithPossibleURL) {
            // Successfully constructed an NSURL; open it
            //UIApplication.sharedApplication().openURL(validURL)
        } else {
            // Initialization failed; alert the user
            let controller: UIAlertController = UIAlertController(title: "Invalid URL", message: "Please try again.", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        if(headingval.isEmpty || category.isEmpty || filedesc.isEmpty || filedesc == "Description")
        {
            let controller: UIAlertController = UIAlertController(title: "Enter Values", message: "Do not left empty Fields", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        else
        {
            activityIndicator.startAnimating()
            
            let headingvalfinal:String = headingval.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            let finaldesc:String = filedesc.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            
            let finalcate:String = category.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            
            let finalname:String = filename.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let values = ["Heading": ""+headingvalfinal,"Desp":""+finaldesc,"MemberID":""+memberidvideo,"Category":""+finalcate,"fileName":""+finalname
                ,"url":""+self.youtubelink.text!]
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(values, options: [])
            
            Alamofire.request(request)
                .responseJSON { response in
                    self.activityIndicator.stopAnimating()
                    // do whatever you want here
                    switch response.result {
                    case .Success(let data):
                        
                        let json = JSON(data).stringValue
                        
                        if(json == "success")
                        {
                            
                            let controller: UIAlertController = UIAlertController(title: "URL UPLOADED", message: "Url successfully uploaded", preferredStyle: .Alert)
                            controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                            
                            self.presentViewController(controller, animated: true, completion: nil)
                            
                        }
                        print(json)
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        
                        let controller: UIAlertController = UIAlertController(title: "UPLOADED ISSUE", message: "Sorry Some Network Issue", preferredStyle: .Alert)
                        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        
                        self.presentViewController(controller, animated: true, completion: nil)
                    }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        activityIndicator.hidesWhenStopped = true
        
        youtubelink.placeholder = "https://www.youtube.com/watch?v="
        youtubelink.text = "https://www.youtube.com/watch?v="
        youtubedes.text = "Description"
        youtubedes.textColor = UIColor.lightGrayColor()
        
        youtubedes.becomeFirstResponder()
        
        youtubedes.selectedTextRange = youtubedes.textRangeFromPosition(youtubedes.beginningOfDocument, toPosition: youtubedes.beginningOfDocument)
        
        homebtn.target = self.revealViewController()
        homebtn.action = Selector("revealToggle:")
        homebtn.image = IonIcons.imageWithIcon(ion_navicon_round, iconColor: UIColor.darkGrayColor(), iconSize: 30, imageSize: CGSize(width: 30, height: 30))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
           self.navigationController?.title = "YouTube Link"
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let name = defaults.stringForKey("USERNAME")
        {
            
            print("user name in myvideo controlleer drawer ")
            
            print(name)
        }
        
        if let memberid = defaults.stringForKey("MEMBERID")
        {
            
            print("Member id  in my video controller  ")
            
            print(memberid)
            
            memberidvideo = memberid
        }
        
        setBorderTxt()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = youtubedes.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            youtubedes.text = "Description"
            youtubedes.textColor = UIColor.lightGrayColor()
            
            youtubedes.selectedTextRange = youtubedes.textRangeFromPosition(youtubedes.beginningOfDocument, toPosition: youtubedes.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if youtubedes.textColor == UIColor.lightGrayColor() && !youtubedes.text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func setBorderTxt()
    {
        
        youtubelink.layer.borderWidth = 2
        youtubelink.layer.borderColor = UIColorFromHex(0x055c8b,alpha:0.8)
            .CGColor
        youtubelink.layer.cornerRadius = 12.0
        
        youtubedes.layer.borderWidth = 2
        youtubedes.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        youtubedes.layer.cornerRadius = 14.0
        
        uploadbtn.layer.cornerRadius = 8.0
    }

    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}