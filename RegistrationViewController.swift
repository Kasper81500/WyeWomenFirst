//
//  RegistrationViewController.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 27/11/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

import UIKit

class RegistrationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate

 {
    @IBOutlet var countylist: UIPickerView!
    
    @IBOutlet var politicalaff: UIPickerView!
    
    @IBOutlet var scrollview: UIScrollView!
    
    @IBOutlet var nameTxt: UITextField!
    
    @IBOutlet var surnameTxt: UITextField!
    
    @IBOutlet var emailTxt: UITextField!
    
    @IBOutlet var passTxt: UITextField!
    
    @IBOutlet var confirmpassTxt: UITextField!
    
    @IBOutlet var countryTxt: UITextField!
    
    
    @IBOutlet var districtTxt: UITextField!
    
    @IBOutlet var cityTxt: UITextField!
    
    
    @IBOutlet var phoneTxt: UITextField!
    
    @IBOutlet var territoryTxt: UITextField!
    
    @IBOutlet var candidateView: UIPickerView!
    
    @IBOutlet var registerBtn: UIButton!
    
    var finalname:String = "";
    var finalsurname:String = "";
    var finalemail:String = "";
    var finalpass:String = "";
    
    @IBOutlet var userphoto: UIImageView!
    
    @IBOutlet var scrollview1: UIScrollView!
    
    var candidateval="";
    var politicalaffval="";
    var countyval="";
    
    var pickerval:String = "";
    var pickerDataSource = [
        "US President",
        "US Vice President",
        "US Senate",
        "US House of Representatives",
        "Governor",
        "Lieutenant Governor",
        "Insurance Commissioner",
        "Attorney General",
        "Clerk of District Court",
        "Commissioner of Education",
        "Commissioner of Labor",
        "Commissioner of State Lands",
        "Comptroller",
        "Corporation Commissioner",
        "County Appraiser",
        "County Attorney",
        "County Clerk",
        "County Commissioner",
        "County Counselor",
        "County Judge",
        "Justice of the Peace",
        "Public Service Commissioner",
        "Register of Deeds",
        "Secretary of Agriculture",
        "Secretary of State",
        "Sheriff",
        "State Auditor And Inspector",
        "State Representative",
        "State Senator",
        "State Treasurer",
        "Superintendent of Public Instruction",
        "Treasurer",
        "Volunteer"];
    
     var politicalaffiliation = [
        "Democrat",
        "Republican",
        "Independent"
        ];
    
    var counties = [
        "Alabama",
        "Alaska",
        "Arizona",
        "Arkansas",
        "California",
        "Colorado",
        "Connecticut",
        "Delaware",
        "Florida",
        "Georgia",
        "Hawaii",
        "Idaho",
        "Illinois Indiana",
        "Iowa",
        "Kansas",
        "Kentucky",
        "Louisiana",
        "Maine",
        "Maryland",
        "Massachusetts",
        "Michigan",
        "Minnesota",
        "Mississippi",
        "Missouri",
        "Montana Nebraska",
        "Nevada",
        "New Hampshire",
        "New Jersey",
        "New Mexico",
        "New York",
        "North Carolina",
        "North Dakota",
        "Ohio",
        "Oklahoma",
        "Oregon",
        "Pennsylvania Rhode Island",
        "South Carolina",
        "South Dakota",
        "Tennessee",
        "Texas",
        "Utah",
        "Vermont",
        "Virginia",
        "Washington",
        "Washington D.C.",
        "West Virginia",
        "Wisconsin",
        "Wyoming"
    ];
    
    var indicator:UIActivityIndicatorView!
    
    func loadUserPhoto(gestureRecognizer: UIGestureRecognizer) {
        
        let ipcVideo = UIImagePickerController()
        ipcVideo.delegate = self        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            ipcVideo.delegate = self
            ipcVideo.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            ipcVideo.allowsEditing = false
            self.presentViewController(ipcVideo, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        userphoto.contentMode = .ScaleAspectFit //3
        userphoto.image = image //4
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        registerBtn.enabled = true
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error == nil {
            self.indicator.stopAnimating()
            self.indicator.willRemoveSubview(self.indicator)
        } else {
            
            self.indicator.stopAnimating()
            self.indicator.willRemoveSubview(self.indicator)

            let alertController = UIAlertController(title: "Image Uploaded Error!", message: "Image Uploaded Server Issue ", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
         }
    }
    
    func URLSession(session:NSURLSession, datatask:NSURLSessionTask ,didReceiveResponse response:NSURLResponse ,completionHandler :(NSURLSessionResponseDisposition)->Void
        ){
            //print(response)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void){
        //  print()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadprogress:Float = Float(totalBytesSent)/Float(totalBytesExpectedToSend)
        
        print(uploadprogress)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == nameTxt { // Switch focus to other text field
            surnameTxt.becomeFirstResponder()
        }else if(textField == surnameTxt){
            emailTxt.becomeFirstResponder()
        }else if(textField == emailTxt){
            passTxt.becomeFirstResponder()
        }else if(textField == passTxt){
            confirmpassTxt.becomeFirstResponder()
        }else if(textField == confirmpassTxt){
            countryTxt.becomeFirstResponder()
        }else if(textField == countryTxt){
            districtTxt.becomeFirstResponder()
        }else if(textField == districtTxt){
            cityTxt.becomeFirstResponder()
        }else if(textField == cityTxt){
            territoryTxt.becomeFirstResponder()
        }else if(textField == territoryTxt){
            phoneTxt.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func registerSendData(sender: AnyObject) {
        enterData()
    }
    
    func enterData(){
        
        let name = nameTxt.text!
        
        let surname = surnameTxt.text!
        
        let email = emailTxt.text!
        
        let pass = passTxt.text!
        
        let confirmpass = confirmpassTxt.text!

        let country = countryTxt.text!
        
        let district = districtTxt.text!
        
        let city = cityTxt.text!
        
        let terroritry = territoryTxt.text!
        
        let phone = phoneTxt.text!
        
        let candidate = "self"
        
        if( email.isEmpty || pass.isEmpty || name.isEmpty || surname.isEmpty || confirmpass.isEmpty || country.isEmpty ||  district.isEmpty || city.isEmpty || phone.isEmpty )
        {
            
            let alertController = UIAlertController(title: "Registration Process!", message: "Please Fill the blank fields", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            
            return
            
        } else {
            
            let value:Bool = isValidEmail(email)
            
            if (value == false)
            {
                displayMessage("Please Enter valid Email")
                emailTxt.text = "";
                emailTxt.becomeFirstResponder()
                
            }
            else if( pass != confirmpass)
            {
                displayMessage("Password not matches ")
                passTxt.text = "";
                confirmpassTxt.text = "";
                passTxt.becomeFirstResponder()
                confirmpassTxt.becomeFirstResponder()
            }
            else
            {
                sendData1(name,surname: surname,email:email,pass:pass,confirmpass:confirmpass,country:country,county:countyval,district:district,city:city,terroritry:terroritry, candidate:candidate, phone:phone)
            }
        }
    }
    
    func sendData1(name:String,surname:String,email:String,pass:String,confirmpass:String,country:String,county:String,district:String,city:String,terroritry:String,candidate:String,phone:String)
    {
        
        let finalname:String = name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalsurname:String = surname.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalpass:String = pass.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!

        let finalcounty:String = countyval.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalpoliticalaff:String = politicalaffval.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finaldistrict:String = district.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalcity:String = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        var finalterritory:String = terroritry.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let finalphone:String = phone.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        if(finalterritory.isEmpty)
        {
            finalterritory = "NA"
        }
        
        print("_________final aff ______")
        print(finalpoliticalaff)
        print(finalterritory)

        print("----------------------------------------------")
        
        let url = NSURL(string:"http://www.womenwomenfirst.com/service/FileUploadService.svc/RegisterMember/"+finalname+"/"+finalsurname+"/"+email+"/"+finalpass+"/"+finalcounty+"/1/"+finaldistrict+"/"+finalcity+"/"+finalterritory+"/"+candidate+"/profilepic.jpg"+"/"+finalphone+"/PoliticalPositionSought"+"/"+finalpoliticalaff)
        
        progressBarView()
      
        let imageData = UIImageJPEGRepresentation(userphoto.image!, 1)
        
        if imageData == nil {
            return
        }
        
        let request = NSMutableURLRequest(URL:url!)
        
        request.HTTPMethod = "POST"
        
        request.setValue("Keep-Alive", forHTTPHeaderField:"Connection")
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: configuration,delegate:self,delegateQueue:NSOperationQueue.mainQueue())
        
        let task = session.uploadTaskWithRequest(request, fromData: imageData!){
            (let data, let response, let error) in
            
            do {
               
                let json:AnyObject =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                    
                    print(json)
                let results:String? = json["RegisterMemberResult"] as? String
                
                if(results == "success")
                {
                    let alertController = UIAlertController(title: "Registration !", message: "Registered Successfully ", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alertController.addAction(OKAction)
                    
                    self.indicator.stopAnimating()
                    self.indicator.willRemoveSubview(self.indicator)
                    self.registerBtn.enabled = false
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginView") as UIViewController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
                else
                {
                    let alertController = UIAlertController(title: "Registration !", message: results, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion:nil)
                    
                    self.indicator.stopAnimating()
                    self.indicator.willRemoveSubview(self.indicator)
                    self.registerBtn.enabled = false
                }
                
             print(results)
                
            } catch {
                // handle error
            }
            
        }
        
        task.resume()
        
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.scrollview.contentSize = CGSizeMake(200,900);
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Border Button
        registerBtn.layer.cornerRadius = 8.0
        
        //Add gesture to the user photo
        let loadUserPhotoGesture = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.loadUserPhoto(_:)))
        self.userphoto.addGestureRecognizer(loadUserPhotoGesture)
        self.userphoto.userInteractionEnabled = true
        
        // Picker view
        self.candidateView.dataSource = self
        self.candidateView.delegate = self
        
        self.countylist.dataSource = self
        self.countylist.delegate = self
        
        self.politicalaff.dataSource = self
        self.politicalaff.delegate = self
        
        // pass delegates to text
        self.nameTxt.delegate = self;
        self.surnameTxt.delegate = self;
        self.emailTxt.delegate = self;
        self.passTxt.delegate = self;
        self.confirmpassTxt.delegate = self;
        self.countryTxt.delegate = self;
       
        self.districtTxt.delegate = self;
        self.cityTxt.delegate = self;
        self.territoryTxt.delegate = self;
        
        let nameView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        nameTxt.leftViewMode = UITextFieldViewMode.Always
        nameTxt.leftView = nameView
        nameTxt.placeholder = "Name"
        
        
        let surnameView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        surnameTxt.leftViewMode = UITextFieldViewMode.Always
        surnameTxt.leftView = surnameView
        surnameTxt.placeholder = "Surname"
        

        let emailView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        emailTxt.leftViewMode = UITextFieldViewMode.Always
        emailTxt.leftView = emailView
        emailTxt.placeholder = "Email"

        let passView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        passTxt.leftViewMode = UITextFieldViewMode.Always
        passTxt.leftView = passView
        passTxt.placeholder = "password"
        
        let conpassView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        confirmpassTxt.leftViewMode = UITextFieldViewMode.Always
        confirmpassTxt.leftView = conpassView
        confirmpassTxt.placeholder = "Confirm password"
        
        let countryView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        countryTxt.leftViewMode = UITextFieldViewMode.Always
        countryTxt.leftView = countryView
        countryTxt.placeholder = "USA"
        
        let districView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        districtTxt.leftViewMode = UITextFieldViewMode.Always
        districtTxt.leftView = districView
        districtTxt.placeholder = "District"
        
        let cityView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        cityTxt.leftViewMode = UITextFieldViewMode.Always
        cityTxt.leftView = cityView
        cityTxt.placeholder = "City"
        
        let terryView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        territoryTxt.leftViewMode = UITextFieldViewMode.Always
        territoryTxt.leftView = terryView
        territoryTxt.placeholder = "Territory"
        
        let phoneView = UIView(frame:CGRect(x:10, y:0, width:20, height:15));
        phoneTxt.leftViewMode = UITextFieldViewMode.Always
        phoneTxt.leftView = phoneView
        phoneTxt.placeholder = "Phone"

        //set border text
        setBorderTexts()
        
        gradientColor()
        
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
    
    func displayMessage(message:String)
    {
        let alertController = UIAlertController(title: "Message Alert", message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed OK button");
            
            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginView") as UIViewController
//                self.presentViewController(viewController, animated: true, completion: nil)
//                
//                
//            })
            
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
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
        
        passTxt.layer.borderWidth = 2
        passTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        passTxt.layer.cornerRadius = 8.0
        
        confirmpassTxt.layer.borderWidth = 2
        confirmpassTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        confirmpassTxt.layer.cornerRadius = 8.0
        
        countryTxt.layer.borderWidth = 2
        countryTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        countryTxt.layer.cornerRadius = 8.0
        
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
        
        phoneTxt.layer.borderWidth = 2
        phoneTxt.layer.borderColor = UIColorFromHex(0x0d7ab5,alpha:0.8)
            .CGColor
        phoneTxt.layer.cornerRadius = 8.0
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView == candidateView){
            return pickerDataSource.count;
        }
        
        if(pickerView == politicalaff){
            return politicalaffiliation.count;
        }
        
        if(pickerView == countylist){
            return counties.count;
        }
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if(pickerView == candidateView)
        {
            candidateval = pickerDataSource[row]
            print(candidateval)
            return pickerDataSource[row]
        }
        
        if(pickerView == politicalaff)
        {
            politicalaffval = politicalaffiliation[row]
            print(politicalaffval)
            return politicalaffiliation[row]
        }

        if(pickerView == countylist)
        {
            countyval = counties[row]
            print(countyval)
            return counties[row]
        }
        
        return ""
        
    }
    
    // Change hex color
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
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
//        
//        print(textField)
//        print("call me return ")
//        
//        textField.resignFirstResponder()
//        
//        return true
//    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        
//        textField.text = ""
//        return  true
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nameTxt.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
