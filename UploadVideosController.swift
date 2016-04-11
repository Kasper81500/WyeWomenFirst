//
//  UploadVideosController.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 04/12/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import MobileCoreServices
import Alamofire
import SwiftyJSON
import ionicons

class UploadVideosController:UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate

{
    
   
    @IBOutlet var filedescription: UITextView!
 
    
    
    @IBOutlet var selectvideo: UIButton!
    
    
    
    @IBOutlet var progresstxt: UILabel!
  

    
  
    @IBOutlet var homebtn: UIBarButtonItem!
    
    
    @IBOutlet var progressbar: UIProgressView!
    
    
     var filename : String = ""
     var filedesc : String = ""
     var category : String = ""
     var urlVideo :NSURL = NSURL()
     var memberidvideo : String = ""
    
    @IBOutlet var headingtxt: UITextField!
  
 
    var headingval:String = ""
    
    @IBOutlet var videodone: UIButton!
    
    var isUploadingVideo : Bool = false
    
    
    @IBAction func sendData(sender: AnyObject) {
        
        if isUploadingVideo == true {
            return
        }
        
        self.videodone.hidden = true
        
        // print ("Click on send")
        self.progresstxt.text = "0%"
        
        self.progressbar.tintColor = UIColorFromHex(0x03dc31,alpha:0.8)
        
        self.progressbar.setProgress(0, animated: false)
        
        filename = "UserVideo"
        
        filedesc = filedescription.text!
        print(filedesc)
        
        category = "UserVideoFiles"
        print(category)
        
        
        if(filedesc.isEmpty || filedesc == "Video Description")
        {
            displayMessage("Please Enter the Video Description")
            
            return
        }
            
        else
        {
            let ipcVideo = UIImagePickerController()
            ipcVideo.delegate = self
            ipcVideo.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            let kUTTypeMovieAnyObject : AnyObject = kUTTypeMovie as AnyObject
            ipcVideo.mediaTypes = [kUTTypeMovieAnyObject as! String]
            self.presentViewController(ipcVideo, animated: true, completion: nil)
        }
    }
    
    @IBAction func stopUploadingVideo(sender: UIButton) {
        if isUploadingVideo == true {
            
            dispatch_async(dispatch_get_main_queue()) {
                Alamofire.Manager.sharedInstance.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
                    for task in dataTasks {
                        task.cancel()
                    }
                    for task in uploadTasks {
                        task.cancel()
                    }
                    for task in downloadTasks {
                        task.cancel()
                    }
                }
                
                self.isUploadingVideo = false
                self.videodone.hidden = true
                self.progressbar.setProgress(0, animated: true)
                self.progresstxt.text = "\(0)%"
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
    
    func setBorderTxt()
    {
        filedescription.layer.borderWidth = 2
        filedescription.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        filedescription.layer.cornerRadius = 16.0
        
        // Log in button
         selectvideo.layer.cornerRadius = 12.0
         videodone.layer.cornerRadius = 12.0
         //videodone.backgroundColor = UIColorFromHex(0x03b157,alpha:1)
        
    }

    
    
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        
      //  print(textField)
     //   print("call me return ")
        
        textField.resignFirstResponder()
        
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        textField.text = ""
        return  true
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        self.view.endEditing(true)
    }
 
    
    
    override func viewDidLoad() {
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        
         self.navigationController?.title = "Upload Video"

        homebtn.target = self.revealViewController()
        homebtn.action = Selector("revealToggle:")
        
        homebtn.image = IonIcons.imageWithIcon(ion_navicon_round, iconColor: UIColor.darkGrayColor(), iconSize: 30, imageSize: CGSize(width: 30, height: 30))

         setBorderTxt()
        
        videodone.hidden = true
        
        filedescription.text = "Video Description"
        filedescription.textColor = UIColor.lightGrayColor()
        
        filedescription.becomeFirstResponder()
        
        filedescription.selectedTextRange = filedescription.textRangeFromPosition(filedescription.beginningOfDocument, toPosition: filedescription.beginningOfDocument)
        /*
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.uploadview.bounds
        
        
        let color1 = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1).CGColor
        let color2 = UIColor(red: 128/255.0, green:128/255.0, blue:128/255.0, alpha:1).CGColor
        

        
        gradientLayer.colors = [color1, color2]
        
        // 4
        gradientLayer.locations = [0.0,  1.3]
        
        // 5
        
        self.uploadview.layer.addSublayer(gradientLayer)
        
        */
        
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let name = defaults.stringForKey("USERNAME")
        {
            
            print("user name   in myvideo controlleer drawer ")
            
            print(name)
            //  username.text = name
        }
        
        if let memberid = defaults.stringForKey("MEMBERID")
        {
            
            print("Member id  in my video controller  ")
            
            print(memberid)
 
            memberidvideo = memberid
            
          //  getList(memberid)
            
            
            // username.text = name
        }
        
        
        progressbar.transform = CGAffineTransformScale(progressbar.transform, 1, 6)
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = filedescription.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            filedescription.text = "Video Description"
            filedescription.textColor = UIColor.lightGrayColor()
            
            filedescription.selectedTextRange = filedescription.textRangeFromPosition(filedescription.beginningOfDocument, toPosition: filedescription.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if filedescription.textColor == UIColor.lightGrayColor() && !filedescription.text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print("chooose path")
        
        urlVideo = info[UIImagePickerControllerMediaURL] as! NSURL
        print("url video ")
        print(urlVideo)
        
        
        
            if(memberidvideo.isEmpty)
            {
                displayMessage("Empty Video")
            }
                
                
            else
                 {
            print("Before upload")
            print(memberidvideo)
            
            
            
            
          //  let finalfilename:String = filename.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            
            
            let finalcategory:String = category.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            

            let finaldescription:String = filedesc.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            
            
            let finalfilevalue = filename.stringByReplacingOccurrencesOfString(" ", withString: "_")
            
        
            
             print("final file name upload ")
             print(finalfilevalue)
            
            
                  //http://applehotelbooking.com/webapi/FileUploadService.svc/UploadFile
                  //
                    
        isUploadingVideo = true;
        self.videodone.setTitle("Cancel", forState: UIControlState.Normal)
        self.videodone.hidden = false
                    
        Alamofire.upload(.POST, "http://www.womenwomenfirst.com/service/FileUploadService.svc/UploadFile/"+finalcategory+"/"+finaldescription+"/"+memberidvideo+"/"+finalcategory+"/"+finalfilevalue+".mp4", file: urlVideo)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                
                
                let uploadProgress:Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes written on main queue: \(uploadProgress)")
                    
                    let progressPercent = Int(uploadProgress*100)
                    
                    
                    self.progressbar.setProgress(uploadProgress, animated: true)
                    
                    self.progresstxt.text = "\(progressPercent)%"
                }
            }
            .responseJSON { response in
               
                if let value: AnyObject = response.result.value {
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["UploadFileResult"]
                    
                    print("Upload video results ")
                    print(results)

                    
                    if(results=="success")
                    {
                        
                         self.displayMessage("Video Uploaded Successfully")
                         self.videodone.setTitle("Done!", forState: UIControlState.Normal)
                         self.isUploadingVideo = false
                    }
                    else
                    {
                         self.displayMessage("Error during Upload")
                         self.videodone.setTitle("Done!", forState: UIControlState.Normal)
                         self.isUploadingVideo = false
                    }
                    
                }
                debugPrint(response)
                
                
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
 
    }

    }
    
}