//
//  ViewController.swift
//  YCRangeSlider
//
//  Created by backslash112 on 09/11/2015.
//  Copyright (c) 2015 backslash112. All rights reserved.
//

import UIKit
import YCRangeSlider

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initRangeSlider()
//        self.view.addSubview(self.slider)
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
//    var slider: YCRangeSlider!
    func initRangeSlider() {
        let slider = YCRangeSlider()
        
        // Setup the Values
        slider.minimumValue = 0
        slider.selectedMinimumValue = 0
        slider.maximumValue = 500
        slider.selectedMaximumValue = 500
        slider.minimumRange = 1
        
        // Setup the custom image
        slider.barBackground = UIImage(named: "tm_bar-background")
        slider.minHandle = UIImage(named: "tm_handle_start")
        slider.maxHandle = UIImage(named: "tm_handle_end")
        slider.popViewBackgroundImage = UIImage(named: "time-machine_popValue_bg")
        
        let height: CGFloat = 463
        let width: CGFloat = 133
        
        slider.initWithFrame2(frame: CGRectMake((self.view.frame.width-width)/2, (self.view.frame.height - height)/2, width, height))
        
        self.view.addSubview(slider)
    }
}

