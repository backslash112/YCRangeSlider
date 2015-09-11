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
        self.view.addSubview(self.slider)
        self.view.backgroundColor = UIColor.grayColor()
    }
    
    var slider: YCRangeSlider!
    func initRangeSlider() {
        self.slider = YCRangeSlider()
        self.slider.minimumValue = 0
        self.slider.selectedMinimumValue = 0
        self.slider.maximumValue = 500
        self.slider.selectedMaximumValue = 500
        self.slider.minimumRange = 1
        
        self.slider.barBackground = UIImage(named: "tm_bar-background")
        self.slider.minHandle = UIImage(named: "tm_handle_start")
        self.slider.maxHandle = UIImage(named: "tm_handle_end")
        self.slider.popViewBackgroundImage = UIImage(named: "time-machine_popValue_bg")
        let height: CGFloat = 463
        let width: CGFloat = 133
        slider.initWithFrame2(frame: CGRectMake((self.view.frame.width-width)/2, (self.view.frame.height - height)/2, width, height))
    }
}

