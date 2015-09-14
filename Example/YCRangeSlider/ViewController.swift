//
//  ViewController.swift
//  YCRangeSlider
//
//  Created by backslash112 on 09/11/2015.
//  Copyright (c) 2015 backslash112. All rights reserved.
//

import UIKit
import YCRangeSlider

class ViewController: UIViewController, YCRangeSliderDelegate {

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
        let slider = YCRangeSlider(frame: self.view.frame, relative: YCRelative.horizontal, minimumValue: 0, maximumValue: 50, step: 10)
        slider.delegate = self
        slider.moveThumbByStep = true
        self.view.addSubview(slider)
    }
    
    // MARK: - YCRangeSliderDelegate
    
    func rangeSlider(rangeSlider: YCRangeSlider, valueChangedWithMinimumValue minimumValue: CGFloat, andMaxiumValue maxiumValue: CGFloat) {
        print("minimumValue: \(minimumValue)  maxiumValue: \(maxiumValue)")
    }
}

