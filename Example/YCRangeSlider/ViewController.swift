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

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
//        self.initRangeSlider()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.initRangeSlider()
    }

    func initRangeSlider() {
        let frame = CGRectMake((self.view.frame.size.width - 200) / 2, (self.view.frame.size.height - 624) / 2, 200, 624)
        let slider = YCRangeSlider(frame: frame, relative: YCRelative.vertical, minimumValue: 1980, maximumValue: 2015, step: 5)
        slider.delegate = self
        slider.moveThumbByStep = true
        self.view.addSubview(slider)
    }
    
    // MARK: - YCRangeSliderDelegate
    
    func rangeSlider(rangeSlider: YCRangeSlider, valueChangedWithMinimumValue minimumValue: CGFloat, andMaxiumValue maxiumValue: CGFloat) {
        // print("YCRangeSliderDelegate minimumValue: \(minimumValue)  maxiumValue: \(maxiumValue)")
    }
}

