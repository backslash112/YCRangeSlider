//
//  YCRangeSlider.swift
//  ios-custom-slider-demo
//
//  Created by Carl.Yang on 9/10/15.
//  Copyright © 2015 Yang Cun. All rights reserved.
//

import UIKit

public class YCRangeSlider: UIControl {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    public var minimumValue: CGFloat = 0
    public var maximumValue: CGFloat = 50
    public var selectedMinimumValue: CGFloat = 0
    public var selectedMaximumValue: CGFloat = 50
    public var minimumRange: CGFloat = 10
    
    public var barBackground: UIImage!
    public var minHandle: UIImage!
    public var maxHandle: UIImage!
    public var popViewBackgroundImage: UIImage!
    
    public var moveThumbByStep = false
    
    var _maxThumbOn = false
    var _minThumbOn = false
    
    public var _padding: CGFloat = 50
    
    var _minThumb: UIImageView!
    var _maxThumb: UIImageView!
    var _track: UIImageView!
    var _trackBackground: UIImageView!
    
    var popView: PopView!
    
    public var self_view_size_width: CGFloat = 500
    public func xForValue(value: CGFloat) -> CGFloat {
        return  (self.frame.width - _padding*2) * (value - minimumValue) / (maximumValue - minimumValue) + _padding
    }
    
    func yForValue(value: CGFloat) -> CGFloat {
        return  (self.frame.size.height - _padding*2) * (value - minimumValue) / (maximumValue - minimumValue) + _padding
    }
    
    public func valueForX(x: CGFloat) -> CGFloat {
        return  ((x - _padding) / (self.frame.width - _padding*2)) * (maximumValue - minimumValue) + minimumValue
    }
    
    func valueForY(y: CGFloat) -> CGFloat {
        return ((y - _padding) / (self.frame.size.height - _padding*2)) * (maximumValue - minimumRange) + minimumValue
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        self.setupBackgroundView()
        self.setupHandleMaxThumb()
        self.setupHandleMinThumb()
    }
    
    public func initWithFrame2(frame frame: CGRect) {
        self.frame = frame
        self.initBackground()
        self.initPopValue()
        self.initMaxThumb()
        self.initMinThumb()
    }
    
    public func init3() {
        self.setupBackgroundView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initBackground() {
        _trackBackground = UIImageView(image: barBackground)
        _trackBackground.frame = CGRectMake(
            self.frame.width - _trackBackground.frame.width,
            _padding,
            _trackBackground.frame.width,
            self.frame.height - _padding*2)
        self.addSubview(_trackBackground)
    }
    
    func initHeighlight() {
        _track = UIImageView(image: UIImage(named: "bar-highlight"))
        _track.frame = CGRectMake(
            (self.frame.width - _track.frame.width)/2,
            _padding,
            _track.frame.width,
            self.frame.height - _padding*2)
        self.addSubview(_track)
    }
    
    func initMinThumb() {
        _minThumb = UIImageView(image: minHandle)
        _minThumb.center = CGPointMake(self.popView.frame.width + (_minThumb.frame.width / 2), self.yForValue(self.selectedMinimumValue))
        self.addSubview(_minThumb)
    }
    
    func initMaxThumb() {
        _maxThumb = UIImageView(image: maxHandle)
        
        _maxThumb.center = CGPointMake(self.popView.frame.width + (_maxThumb.frame.width / 2), self.yForValue(self.selectedMaximumValue))
        self.addSubview(_maxThumb)
    }
    
    func initPopValue() {
        
        self.popView = PopView(image: popViewBackgroundImage)
        self.popView.sizeToFit()
        self.popView.hidden = true
        self.popView.center = CGPointMake(self.popView.frame.width/2, 0)
        self.addSubview(self.popView)
    }
    
    public var step: Int = 10
    public var unit: Int = 1
    
    let UNIT_WIDTH: CGFloat = 1
    let UNIT_HEIGHT: CGFloat = 10
    let STEP_HEIGHT: CGFloat = 15
    
    func setupBackgroundView() {
        // Draw the base line
        let lineHeight: CGFloat = 1
        let lineWidth: CGFloat = self.frame.width - _padding*2
        let line = UIView(frame: CGRectMake(0, 0, lineWidth, lineHeight))
        line.center = self.center
        line.backgroundColor = UIColor.whiteColor()
        self.addSubview(line)
        
        let unitWidth = lineWidth / CGFloat((maximumValue - minimumValue))
        for unit in 0...Int(maximumValue - minimumValue) {
            if unit % step == 0 { // Add step to the base line
                let stepLine: UIView = UIView(frame: CGRectMake(
                    _padding + unitWidth * CGFloat(unit),
                    line.center.y - STEP_HEIGHT,
                    UNIT_WIDTH,
                    STEP_HEIGHT))
                stepLine.backgroundColor = UIColor.whiteColor()
                self.addSubview(stepLine)
                
                let stepNumber: UILabel = UILabel()
                stepNumber.text = "\(unit)"
                stepNumber.textColor = UIColor.whiteColor()
                stepNumber.font = UIFont.systemFontOfSize(10)
                stepNumber.sizeToFit()
                
                stepNumber.center = CGPointMake(stepLine.center.x, stepLine.center.y - STEP_HEIGHT)
                self.addSubview(stepNumber)
                
            } else { // Add unit to the base line
                let unitLine: UIView = UIView(frame: CGRectMake(
                    _padding + unitWidth * CGFloat(unit),
                    line.center.y - UNIT_HEIGHT,
                    UNIT_WIDTH,
                    UNIT_HEIGHT))
                
                unitLine.backgroundColor = UIColor.whiteColor()
                self.addSubview(unitLine)
            }
        }
    }
    
    
    func setupHandleMinThumb() {
        _minThumb = UIImageView(image: UIImage(named: "handle"))
        _minThumb.sizeToFit()
        _minThumb.center = CGPointMake(self.xForValue(0), ((self.frame.height - STEP_HEIGHT)) / 2 - STEP_HEIGHT - 20)
        self.addSubview(_minThumb)
    }
    
    func setupHandleMaxThumb() {
        _maxThumb = UIImageView(image: UIImage(named: "handle"))
        _maxThumb.sizeToFit()
        _maxThumb.center = CGPointMake(self.xForValue(50), ((self.frame.height - STEP_HEIGHT)) / 2 - STEP_HEIGHT - 20)
        self.addSubview(_maxThumb)
    }
    
    // MARK: - Tracking Touch
    
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let touchPoint = touch.locationInView(self)
        if CGRectContainsPoint(_minThumb.frame, touchPoint) {
            _minThumbOn = true
        } else if CGRectContainsPoint(_maxThumb.frame, touchPoint) {
            _maxThumbOn = true
        }
        return true
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if !_maxThumbOn && !_minThumbOn {
            return true
        }
        let touchPoint = touch.locationInView(self)
        if _minThumbOn {
            _minThumb.center = CGPointMake(max(self.xForValue(self.minimumValue), min(touchPoint.x, self.xForValue(self.selectedMaximumValue - self.minimumRange))), _minThumb.center.y)
            self.selectedMinimumValue = self.valueForX(_minThumb.center.x)
        }
        if _maxThumbOn {
            _maxThumb.center = CGPointMake(min(max(self.xForValue(self.selectedMinimumValue + self.minimumRange), touchPoint.x), self.xForValue(self.maximumValue)), _maxThumb.center.y)
            self.selectedMaximumValue = self.valueForX(_maxThumb.center.x)
        }
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        _maxThumbOn = false
        _minThumbOn = false
        
        // Adjust the minThumb's location
        var minThumbRoundValue:  CGFloat!
        if self.moveThumbByStep {
            minThumbRoundValue  = self.getTheRoundValue(Int(self.selectedMinimumValue), bySection: self.step)
        } else {
            minThumbRoundValue  = self.getTheRoundValue(Int(self.selectedMinimumValue), bySection: self.unit)
        }
        self.adjustThumbCenter(self._minThumb, byNewValue: minThumbRoundValue)
        self.selectedMinimumValue = minThumbRoundValue
        
        // Adjust the maxThumb's location
        var maxThumbRoundValue: CGFloat!
        
        if self.moveThumbByStep {
            maxThumbRoundValue = self.getTheRoundValue(Int(self.selectedMaximumValue), bySection: self.step)
        } else {
            maxThumbRoundValue = self.getTheRoundValue(Int(self.selectedMaximumValue), bySection: self.unit)
        }
        self.adjustThumbCenter(self._maxThumb, byNewValue: maxThumbRoundValue)
        self.selectedMaximumValue = maxThumbRoundValue
    }
    
    /*
    Get the round value by section.
    e.g. if the section is 5, then the value must be 0, 5, 10, 15; if the section is 3, then the value must be 0, 3, 6, 9, 12
    */
    func getTheRoundValue(value: Int, bySection section: Int) -> CGFloat {
        if value == 0 {
            return 0
        }
        if value % section == 0 {
            return CGFloat(value)
        }
        let pre = value / section * section
        let next = (value / section + 1) * section
        if (value - pre) < (next - value) {
            return CGFloat(pre)
        } else {
            return CGFloat(next)
        }
    }
    
    func adjustThumbCenter(thumb: UIView, byNewValue value: CGFloat) {
        let newX = self.xForValue(value)
        UIView.animateWithDuration(0.3) { () -> Void in
            thumb.center = CGPointMake(newX, thumb.center.y)
        }
    }
}








