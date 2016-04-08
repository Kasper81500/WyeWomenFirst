//
//  VideoListView.swift
//  WyeWomenFirst
//
//  Created by Deepak Sharma on 27/11/15.
//  Copyright © 2015 blitzinfosystem. All rights reserved.
//

import Foundation

import UIKit

class VideoListView:UIViewController
{
    
    @IBOutlet var backBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        backBtn.enabled = true
        backBtn.target = self.revealViewController()
        backBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    
    
    
    
}
