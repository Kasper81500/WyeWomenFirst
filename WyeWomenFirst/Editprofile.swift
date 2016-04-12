//
//  Editprofile.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 22/12/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
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

class Editprofile :UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate,UITextFieldDelegate
{
    @IBOutlet var homeback: UIBarButtonItem!
 
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var surnameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var cityTxt: UITextField!
    @IBOutlet var countyTxt: UITextField!
    @IBOutlet var countryTxt: UITextField!
    @IBOutlet var districtTxt: UITextField!
    @IBOutlet var territoryTxt: UITextField!
    @IBOutlet var candidateTxt: UITextField!
    @IBOutlet var phoneTxt: UITextField!
    
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
    var memberpicurl:String = ""
    var phonevalue:String = ""
    var indicator:UIActivityIndicatorView!

    
    @IBOutlet var editprofileBtn: UIButton!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var uploadimage: UIButton!
    @IBOutlet var imageview: UIImageView!
    
    
    var imagepic:String = ""
    
    func loadUserPhoto(gestureRecognizer: UIGestureRecognizer){
        
        let ipcVideo = UIImagePickerController()
        ipcVideo.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            
            print("Button capture")
            
            ipcVideo.delegate = self
            ipcVideo.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            ipcVideo.allowsEditing = false
            
            self.presentViewController(ipcVideo, animated: true, completion: nil)
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
    
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      
        imageview.contentMode = .ScaleAspectFit //3
        imageview.image = image //4
        
        let imageData = UIImageJPEGRepresentation(imageview.image!, 1)
        
        if(imageData == nil)
        {
            return
        }
        
        print("member id "+memberpicurl);
        
        let uploadurl = NSURL(string:"http://www.womenwomenfirst.com/service/FileUploadService.svc/UploadProfileImage/"+memberpicurl+"/profilemyimage.jpg/")
        
        print(uploadurl)
        
        let request = NSMutableURLRequest(URL:uploadurl!)
        
        request.HTTPMethod = "POST"
        
        request.setValue("Keep-Alive", forHTTPHeaderField:"Connection")
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: configuration,delegate:self,delegateQueue:NSOperationQueue.mainQueue())
        
        let task = session.uploadTaskWithRequest(request, fromData: imageData!)
        
        task.resume()
        
        progressBarView()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func URLSession(session:NSURLSession, task:NSURLSessionTask ,didCompleteWithErro error:NSURLError) {
        
        
       
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error == nil {
           // print("session \(session) upload completed")
            
            let alertController = UIAlertController(title: "Image Uploaded!", message: "Image Uploaded Successfully ", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            
            self.indicator.stopAnimating()
            self.indicator.willRemoveSubview(self.indicator)
            
        } else {
            
            let alertController = UIAlertController(title: "Image Uploaded Error!", message: "Image Uploaded Server Issue ", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            
        }
    }
    
    
    func URLSession(session:NSURLSession, datatask:NSURLSessionTask ,didReceiveResponse response:NSURLResponse ,completionHandler :(NSURLSessionResponseDisposition)->Void
         ){
        
           // print(response)
        
    }
    
  func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void)
    
    {
      //  print()
    }
    
   func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    
   {
        let uploadprogress:Float = Float(totalBytesSent)/Float(totalBytesExpectedToSend)
        
        print(uploadprogress)

    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        homeback.target = self.revealViewController()
        homeback.action = Selector("revealToggle:")
        homeback.image = IonIcons.imageWithIcon(ion_navicon_round, iconColor: UIColor.darkGrayColor(), iconSize: 30, imageSize: CGSize(width: 30, height: 30))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        editprofileBtn.layer.cornerRadius = 8.0
        
        setBorderTexts()
        gradientColor()
        progressBarView()
        
        nameTxt.placeholder = "Name"
        surnameTxt.placeholder = "Surname"
        emailTxt.placeholder = "Email"
        countryTxt.placeholder = "Country"
        countyTxt.placeholder = "County"
        districtTxt.placeholder = "District"
        cityTxt.placeholder = "City"
        territoryTxt.placeholder = "Territory"
        candidateTxt.placeholder = "Candidate"
        phoneTxt.placeholder = "Phone"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let name = defaults.stringForKey("USERNAME")
        {

            
        }
        
        if let memberid = defaults.stringForKey("MEMBERID")
        {
            memberpicurl = memberid
            
            getList(memberid)
        }
    
        //Add gesture to the user photo
        let loadUserPhotoGesture = UITapGestureRecognizer(target: self, action: #selector(Editprofile.loadUserPhoto(_:)))
        self.imageview.addGestureRecognizer(loadUserPhotoGesture)
        self.imageview.userInteractionEnabled = true
    }
   
    @IBAction func sendData(sender: AnyObject) {
        
        enterData()
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
    
    func enterData()
    {
        var name : String
        name = nameTxt.text!
       // print(name)
        
        var surname : String
        surname = surnameTxt.text!
       // print(surname)
        
        var email : String
        email = emailTxt.text!
      //  print(email)
        
        var country : String
        country = countryTxt.text!
     //   print(country)
        
        var county : String
        county = countyTxt.text!
     //   print(county)
        
        var district : String
        district = districtTxt.text!
      //  print(district)
        
        var city : String
        city = cityTxt.text!
       // print(city)
        
        var terroritry : String
        terroritry = territoryTxt.text!
      //  print(terroritry)
        
        var phone : String
        phone = phoneTxt.text!
      //  print(phone)
        
        var candidate : String
        candidate = "self"
     //   print(candidate)
        
        if( email.isEmpty || name.isEmpty || surname.isEmpty ||  country.isEmpty || county.isEmpty || district.isEmpty || city.isEmpty || terroritry.isEmpty  || candidate.isEmpty || phone.isEmpty )
        {
            
            let alertController = UIAlertController(title: "Registration Process!", message: "Please Enter Values  ", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            
            return
        }
        else
        {
            //print("inside else ")
            
            let value:Bool = isValidEmail(email)
            if (value == false)
            {
                displayMessage("Please Enter valid Email")
            }
            else
            {
                sendData1(name,surname: surname,email:email,country:country,county:county,district:district,city:city,terroritry:terroritry,candidate: candidate,phone:phone)
            }
        }
    }
    
    func sendData1(name:String,surname:String,email:String,country:String,county:String,district:String,city:String,terroritry:String,candidate:String,phone:String)
    {
        
        
        let finalname:String = name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalsurname:String = surname.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalcountry:String = country.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalcounty:String = county.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finaldistrict:String = district.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalcity:String = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalterritory:String = terroritry.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalphone:String = phone.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/Service1.svc/Updatemember/1/"+finalname+"/"+finalsurname+"/"+email+"/"+finalcounty+"/"+finalcountry+"/"+finaldistrict+"/"+finalcity+"/"+finalterritory+"/"+candidate+"/"+finalphone+"/PPS/PA")
        
            Alamofire.request(.POST, url!,  encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    self.displayMessage(String(response.result.error))
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let swiftyJsonVar = JSON(value)
                    let results = swiftyJsonVar["UpdateMemberResult"]
                    
                    //  print(results)
                    
                    if(results=="success"){
                        print("come in success ")
                        self.displayMessage("Successfully Updated")
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Updation Failed!", message: "This Email already registered  ", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)
                    }
                }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.scrollview.contentSize = CGSizeMake(200,750);
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
    
    // -------------       Get List ------ ---------------------------- //
    func setBorderTexts()
    {
        nameTxt.layer.borderWidth = 2
        nameTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        nameTxt.layer.cornerRadius = 8.0
        
        surnameTxt.layer.borderWidth = 2
        surnameTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        surnameTxt.layer.cornerRadius = 8.0
        
        emailTxt.layer.borderWidth = 2
        emailTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        emailTxt.layer.cornerRadius = 8.0
        
        countryTxt.layer.borderWidth = 2
        countryTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        countryTxt.layer.cornerRadius = 8.0
        
        countyTxt.layer.borderWidth = 2
        countyTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        countyTxt.layer.cornerRadius = 8.0
        
        districtTxt.layer.borderWidth = 2
        districtTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        districtTxt.layer.cornerRadius = 8.0
        
        cityTxt.layer.borderWidth = 2
        cityTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        cityTxt.layer.cornerRadius = 8.0
        
        territoryTxt.layer.borderWidth = 2
        territoryTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        territoryTxt.layer.cornerRadius = 8.0
        
        candidateTxt.layer.borderWidth = 2
        candidateTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        candidateTxt.layer.cornerRadius = 8.0
        
        phoneTxt.layer.borderWidth = 2
        phoneTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        phoneTxt.layer.cornerRadius = 8.0
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
        
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
                    // print(swiftyJsonVar)
                    
                    
                    let results = swiftyJsonVar["GetMemberResult"]
                    
                    // print(results)
                    
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
                            
                            self.nameTxt.text = self.namevalue
                            self.surnameTxt.text = self.surnamevalue
                            self.emailTxt.text = self.emailvalue
                            self.cityTxt.text = self.cityvalue
                            self.countyTxt.text = self.countyvalue
                            self.countryTxt.text = self.countyvalue
                            self.districtTxt.text = self.districtvalue
                            self.territoryTxt.text = self.territoryvalue
                            self.candidateTxt.text = self.candidatevalue
                            self.phoneTxt.text = self.phonevalue
                            
                            self.indicator.stopAnimating()
                            self.indicator.willRemoveSubview(self.indicator)
                            
                            let url = NSURL(string: self.imagepic)
                        
                               // let url = NSURL(string: memberimage)
                                //   let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                                // imageuser.image = UIImage(data: data!)
                                
                                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
                                    //			println(self)
                                }
                                
                                // let url = NSURL(string: "http://yikaobang-test.u.qiniudn.com/FnZTPYbldNXZi7cQ5EJHmKkRDTkj")
                                
                                self.imageview.sd_setImageWithURL(url, completed: block)
                            
                        }
           
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
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
    
}