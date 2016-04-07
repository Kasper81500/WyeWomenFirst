//
//  LoginViewController.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 27/11/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit



class LoginViewController: UIViewController ,UITextFieldDelegate, UIAlertViewDelegate {
    
    var indicator:UIActivityIndicatorView!
    
    @IBOutlet var emailText: UITextField!
    
    var usernametweet:String?
    
    var useridtweet:String?
    
    var userimage:String?
    
    @IBOutlet var forgetpasswordBtn: UIButton!
    
    @IBOutlet var registerBtn: UIButton!
    
    
    @IBOutlet var sendTwitter: UIButton!
    
    
    
    
    
    @IBAction func sendForget(sender: AnyObject) {
        
        var email : String
        email = emailText.text!
        //  print(email)
        
        
        if( email.isEmpty )
        {
            
            
            // displayMessage("Please Enter Values")
            let alertController = UIAlertController(title: "Warning!", message: "Please Enter Email", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            
            return
            
        }
            
        else
        {
            sendForgetData(email)
        }

        
        
        
        
        
    }
    
    
    
    func sendForgetData(emailval:String)

    {
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/service1.svc/ForgotPassword/"+emailval)
        
        
        
        // print(url)
        
        Alamofire.request(.POST, url!,  encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    self.displayMessage(String(response.result.error))
                    self.displayMessage("Some Network Issue")
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["ForgotPasswordResult"]
                    let ans = String(results)
                    
                    //print(results)
                    let alertController = UIAlertController(title: "Email Sent", message: " "+ans, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion:nil)
                    
                    
                }
        }
        
        
        
        
        

    }
    
    
    
    
    
    @IBAction func registerSend(sender: AnyObject) {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Register") as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
        
        
    }
    
    
    
    
    @IBAction func sendTwitterValue(sender: AnyObject) {
        
        
        print("send")
        Twitter.sharedInstance().logInWithCompletion {
            (session, error) -> Void in
            if (session != nil) {
                
                
                
                
                print("signed in as \(session!.userName)");
                print("signed in as user id \(session!.userID)");
                
                self.usernametweet = session!.userName
                self.useridtweet = session!.userID
                
            }
            
            
            Twitter.sharedInstance().APIClient.loadUserWithID( session!.userID )
                {
                    (user, error) -> Void in
                    
                    if( user != nil )
                    {
                     //   print( self.usernametweet! )
                        
                        print(user!.profileImageURL )
                        self.userimage = user!.profileImageURL
                        
                        self.checkTwitterSession(self.useridtweet!, usernametwitter: self.usernametweet!,userimage:self.userimage!)
                        
                       
                    }
            }
       
            

            
            
        
        
        }
        
        
    
    
    
    }

    
    
        

    func checkTwitterSession(userid:String,usernametwitter:String,userimage:String)
    {
        
        
        
        print("user id ")
        print(userid)
        print(usernametwitter)
        
        progressBarView()
  
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/service1.svc/MemberLoginuserForTwitter/twitter/"+userid);
            
///"+usermail+"/"+facebook+"/"+userid)
        
        //    print("urlllllll")
        print(url)
        
        
        
        
        Alamofire.request(.POST, url!,  encoding: .JSON)
            .responseJSON {
                response in
                guard response.result.error == nil else {
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["MemberLoginuserForTwitterResult"]
                    
                    //   print(results)
                    let message = results["Message"]
                    
                    
                    
                    
                    if(message=="invalid user")
                    {
                        
                        
                         print("user not locate ")
                        
                        
                        let alertController = UIAlertController(title: "NEW USER!", message: "Registration Process ", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            
                            
                            
                            self.registerTwitterSession(self.useridtweet!, usernametwitter: self.usernametweet!,userimage:self.userimage!)
                            
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)
                        
                        
                        
                        return
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    if(message=="success")
                    {
                        
                           print("success")
                        
                        
                        let alertController = UIAlertController(title: "Login!", message: " Registered User ", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as UIViewController
                                self.presentViewController(viewController, animated: true, completion: nil)
                                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                prefs.setObject(usernametwitter, forKey: "USERNAME")
                                prefs.setObject(userimage, forKey: "USERIMAGE")
                                prefs.setObject(userid, forKey: "MEMBERID")
                                prefs.synchronize()
                                
                                
                            })
                            
                            
                            
                            
                            
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)
                        
                        

                        
                    }
                    
                    
                    
                    
                    
                }
                
                
                
        }
        
        self.indicator.stopAnimating()
        self.indicator.willRemoveSubview(self.indicator)
        
        
        
        
        
    }
    
    
    
    
    func registerTwitterSession(userid:String,usernametwitter:String,userimage:String)
    {
        
        
        
        print("user id ")
        print(userid)
        print(usernametwitter)

        progressBarView()
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/RegisterFromTwitter/"+usernametwitter+"/"+userid+"/twitter");
        
        ///"+usermail+"/"+facebook+"/"+userid)
        
        //    print("urlllllll")
        print(url)
        
        
        
        
        Alamofire.request(.POST, url!,  encoding: .JSON)
            .responseJSON {
                response in
                guard response.result.error == nil else {
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["RegisterFromTwitterResult"]
                    
                    //   print(results)
                    let message = results["Message"]
                    
                    
                    
                    if(message=="success")
                    {
                        
                        print("success")
                        
                        
                        
                        
                        let alertController = UIAlertController(title: "Registration!", message: "Successfully Registered", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as UIViewController
                                self.presentViewController(viewController, animated: true, completion: nil)
                                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                prefs.setObject(usernametwitter, forKey: "USERNAME")
                                prefs.setObject(userimage, forKey: "USERIMAGE")
                                prefs.setObject(userid, forKey: "MEMBERID")
                                prefs.synchronize()
                                
                                
                            })
                            
                            
                            
                            
                            
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
                
                
        }
        
        self.indicator.stopAnimating()
        self.indicator.willRemoveSubview(self.indicator)
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
   
    @IBAction func sendFaceBook(sender: AnyObject) {
        
        
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], fromViewController:self,  handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    
                    
                  //  print("Get User facebook data ")
                 //   print(self.getFBUserData())
                    
                    
                    fbLoginManager.logOut()
                }
            }
        })
        
    }
  
    
    @IBOutlet var passText: UITextField!
    


    @IBOutlet var sendBtnn: UIButton!
 
  
  
    @IBAction func sendLogin(sender: AnyObject) {
         enterData()
    }
    
    
    @IBAction func sendRegistration(sender: AnyObject) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setBorderTxt()
        
        
        gradientColor()
        
       // emailText.contentHorizontalAlignment = 5
        
        let spacerView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        emailText.leftViewMode = UITextFieldViewMode.Always
        emailText.leftView = spacerView
        
        
        
        let spacerViewpass = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        passText.leftViewMode = UITextFieldViewMode.Always
        passText.leftView = spacerViewpass
       
        
        
        
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

    
    func getFBUserData()
        
        
        
    {
        if((FBSDKAccessToken.currentAccessToken()) != nil)
            
            
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil)
                    
                {
                 //   self.dict = result as! NSDictionary
                  //  print("*****************")
                    let userid = result.valueForKey("id") as? String
                    
                    let usermail = result.valueForKey("email") as? String
                    print(usermail!)
                    
                    
                    
                    
                    
                    
                   let username = result.valueForKey("name") as? String
                    
                    print(username!)
                    
                    print(userid!)
                    
                 //   let imageval:UIImage =  self.getProfPic(userid!)!
                    
                    //print("imageval------")
                   // print(imageval)
                    
                    
                    
                    
                    print("fb sdk session token ")
                    print(FBSDKAccessToken.currentAccessToken)
                    
                    self.checkDataSession(userid!,usernamefacebook:username!,usermail: usermail!,facebook: "facebook")
                    
                    
                                  }
                
                
            })
        }
    }
    
    
    
    
    func getProfPic(fid: String) -> UIImage? {
        if (fid != "") {
            let imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
            let imgURL = NSURL(string: imgURLString)
            let imageData = NSData(contentsOfURL: imgURL!)
            let image = UIImage(data: imageData!)
            
            print("get profile pic")
            print(image)
            
            
            return image
        }
        return nil
    }

    
    
    func checkDataSession(userid:String,usernamefacebook:String,usermail:String,facebook:String)
    {
        
        progressBarView()
        
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/service1.svc/MemberLoginFromSocial/"+usermail+"/"+facebook+"/"+userid)
        
    //    print("urlllllll")
       print(url)
        
        
        
        
        Alamofire.request(.POST, url!,  encoding: .JSON)
            .responseJSON {
                response in
                guard response.result.error == nil else {
                                      return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["MemberLoginFromSocialResult"]
                    
                 //   print(results)
                    let message = results["Message"]
                    
                    
                    
                    
                    if(message=="invalid user")
                    {
                        
                        
                       // print("user not locate ")
                        
                        let alertController = UIAlertController(title: "NEW USER!", message: "Registration Process ", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                     
                            
                          
                            self.registerUserFaceBook(String(userid),username:String(usernamefacebook),usermail: String(usermail),facebook: "facebook")
                        
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)

                        
                        
                        return
                    }
                    
                    
                    
                    if(message=="success")
                    {
                        
                     //   print("success")
                        
                        let memberid: String? = results["MemberID"].stringValue
                        let usernamefbval: String? = results["Name"].stringValue

                         print(memberid!)
                        
                         print(usernamefbval!)
                 
                        let imgURLString = "http://graph.facebook.com/" + userid + "/picture?type=large"
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as UIViewController
                            self.presentViewController(viewController, animated: true, completion: nil)
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(usernamefbval, forKey: "USERNAME")
                            prefs.setObject(imgURLString, forKey: "USERIMAGE")
                            prefs.setObject(memberid, forKey: "MEMBERID")
                            prefs.synchronize()
                            
                            
                        })
                        
                        
                    }
                    
                   
                }
                
        }
        
        
        
    }

    
    
    func registerUserFaceBook(userid:String,username:String ,usermail:String,facebook:String)
    {
        
      
        let finalname:String = username.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        

        
        
        let urlregister = NSURL(string:"http://www.womenwomenfirst.com/service/service1.svc/RegisterFromSocial/"+finalname+"/"+usermail+"/"+userid+"/"+facebook)
        
        print("register url")
        print(urlregister)

        
        Alamofire.request(.POST, urlregister!,  encoding: .JSON)
            .responseJSON {
                response in
                guard response.result.error == nil else {
                                      return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["RegisterFromSocialResult"]
                   
                    
                    
                    let message = results["Message"]

                    
                    
                    
                    
                    
                    if(message == "success")
                    {
                        
                        
                         let memberid = results["MemberID"].stringValue
                        
                        //   print("Member id in login view ")
                        print("id is\(memberid)")
                        
                        
                        //  let usertypeid = results["UserTypeID"].stringValue
                        
                        let username = results["Name"].stringValue

                        print(username)
                        
                        
                          let imgURLString = "http://graph.facebook.com/" + userid + "/picture?type=large"
                        
                        
                        
                    
                    let alertController = UIAlertController(title: "Registration!", message: "Successfully Registered", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as UIViewController
                            self.presentViewController(viewController, animated: true, completion: nil)
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(username, forKey: "USERNAME")
                            prefs.setObject(imgURLString, forKey: "USERIMAGE")
                            prefs.setObject(memberid, forKey: "MEMBERID")
                            prefs.synchronize()
                            
                            
                        })
                       
                        
                        
                        
                        
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)

                        
                        self.indicator.stopAnimating()
                        self.indicator.willRemoveSubview(self.indicator)
                        
                        
                      
                        
                    }
                    
                        
                    }
                
        }
       

    }
    
    
    
    
    
    
    
    
    
    func gradientColor()
    {
        
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        
        let color1 = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1).CGColor
        let color2 = UIColor(red: 128/255.0, green:128/255.0, blue:128/255.0, alpha:1).CGColor
        
        
        
        gradientLayer.colors = [color1, color2]
        
        
        // 4
        gradientLayer.locations = [0.0,  2.6]
        
        // 5
        
        self.view.layer.addSublayer(gradientLayer)

        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func enterData()
    {
        
        var email : String
        email = emailText.text!
      //  print(email)
        
        
        var pass : String
        pass = passText.text!
      //  print(pass)
        
        
        if( email.isEmpty || pass.isEmpty)
        {
            
            
           // displayMessage("Please Enter Values")
            let alertController = UIAlertController(title: "Warning!", message: "Please Enter Values", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            
                     return
            
        }
            
        else
        {
            sendData(email,passval: pass)
        }
        
    }
    
    

    
    func sendData(emailval:String , passval:String)
    {
        
        print("email val")
        print(emailval)
        print("pass val")
        print(passval)
        
        
        
        
       // let url = NSURL(string:"http://applehotelbooking.com/webapi/Service1.svc/memberlogin/Test@gmail.com/123456")
        
        
     //   let url = NSURL(string:"http://applehotelbooking.com/webapi/Service1.svc/memberlogin/"+emailval+"/"+passval)
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/MemberLogin/"+emailval+"/"+passval)
        
        
        
       // print(url)
        
        Alamofire.request(.POST, url!,  encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    self.displayMessage(String(response.result.error))
                    self.displayMessage("Some Network Issue")
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["MemberLoginResult"]
                    
                      print(results)
                     let message = results["Message"]
                    
                    print("message")
                    print(message)
                    
                    
                    if(message=="Invalid")
                    {
                        
                        print("its invalid ")
                        let alertController = UIAlertController(title: "Login Failed!", message: "Member Password or Email Mismatch ", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)

                    
                        return
                    }
                    
                    
                    
                    if(message=="success")
                    {
                        
                        
                        
                        let memberid = results["MemberID"].stringValue
                        
                        print("Member id in login view ")
                        print("id is\(memberid)")
                        
                        
                        let membername = results["Name"].stringValue
                       
                        
                        let memberimage = results["UserImage"].stringValue
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as UIViewController
                            self.presentViewController(viewController, animated: true, completion: nil)
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(membername, forKey: "USERNAME")
                            prefs.setObject(memberimage, forKey: "USERIMAGE")
                            prefs.setObject(memberid, forKey: "MEMBERID")
                            prefs.synchronize()
                            
                            
                        })
                        
                    }
                   
                    
                    
                   // print("The post is: " + swiftyJsonVar.description)
                }
        }
        
         }
    
    
    

    
    
    func setBorderTxt()
    {
        
        emailText.layer.borderWidth = 2
        emailText.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        emailText.layer.cornerRadius = 16.0
        emailText.placeholder = "Email"
        
        
        passText.layer.borderWidth = 2
        passText.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        passText.layer.cornerRadius = 16.0
        passText.placeholder = "Password"
        
        // = UIEdgeInsetsMake(-4,-8,0,0);
        
        
        // Log in button
        
        sendBtnn.layer.cornerRadius = 16.0
        
        
        
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

    
    
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        
        print(textField)
        print("call me return ")
        
        textField.resignFirstResponder()
        
        /*
        if (textField == emailTxt) {
        textField.resignFirstResponder()
        passTxt.becomeFirstResponder()
        }
        */
        
        return true
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        emailText.resignFirstResponder()
        self.view.endEditing(true)
    }

    

    
}
