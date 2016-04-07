//
//  Photo.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 04/01/16.
//  Copyright © 2016 blitzinfosystem. All rights reserved.
//

import Foundation
class Photo {
    class func upload(image: UIImage, filename: String) -> Request {
        let route = Router.CreatePhoto()
        var request = route.URLRequest.mutableCopy() as NSMutableURLRequest
        let boundary = "NET-POST-boundary-\(arc4random())-\(arc4random())"
        request.setValue("multipart/form-data;boundary="+boundary,
            forHTTPHeaderField: "Content-Type")
        
        let parameters = NSMutableData()
        for s in ["\r\n--\(boundary)\r\n",
            "Content-Disposition: form-data; name=\"photos[photo]\";" +
            " filename=\"\(filename)\"\r\n",
            "Content-Type: image/png\r\n\r\n"] {
                parameters.appendData(s.dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        parameters.appendData(UIImageJPEGRepresentation(image, 1))
        parameters.appendData("\r\n--\(boundary)--\r\n"
            .dataUsingEncoding(NSUTF8StringEncoding)!)
        return Alamofire.upload(request, parameters)
    }
}