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
    
    //    func initMinThumb() {
    //        _minThumb = UIImageView(image: UIImage(named: "handle"))
    //        _minThumb.center = CGPointMake(self.xForValue(self.selectedMinimumValue), self.frame.size.height/2)
    //        self.addSubview(_minThumb)
    //    }
    
    func initMinThumb() {
        _minThumb = UIImageView(image: minHandle)
        _minThumb.center = CGPointMake(self.popView.frame.width + (_minThumb.frame.width / 2), self.yForValue(self.selectedMinimumValue))
        self.addSubview(_minThumb)
    }
    
    //    func initMaxThumb() {
    //        _maxThumb = UIImageView(image: UIImage(named: "handle"))
    //        _maxThumb.center = CGPointMake(self.xForValue(self.selectedMaximumValue), self.frame.size.height/2)
    //        self.addSubview(_maxThumb)
    //    }
    
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
    
    // MARK: - Tracking Touch
    
    //    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    //        let touchPoint = touch.locationInView(self)
    //        if CGRectContainsPoint(_minThumb.frame, touchPoint) {
    //            _minThumbOn = true
    //            self.popView.hidden = false
    //            self.popView.center = CGPointMake(self.popView.center.x, _minThumb.center.y)
    //            self.popView.popValue = "\(_minThumb.center.y)"
    //        } else if CGRectContainsPoint(_maxThumb.frame, touchPoint) {
    //            _maxThumbOn = true
    //            self.popView.hidden = false
    //            self.popView.center = CGPointMake(self.popView.center.x, _maxThumb.center.y)
    //            self.popView.popValue = "\(_maxThumb.center.y)"
    //        }
    //        return true
    //    }
    //
    //    override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    //        _minThumbOn = false
    //        _maxThumbOn = false
    //        self.popView.hidden = true
    //    }
    
    //    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    //        if !_minThumbOn && !_maxThumbOn {
    //            return true
    //        }
    //
    //        let touchPoint = touch.locationInView(self)
    //        if _minThumbOn {
    //            let minimumX = self.xForValue(self.minimumValue)
    //            print("minimumX \(minimumX)")
    //            print("selectedMaximumValue \(selectedMaximumValue)")
    //            print("selectedMaximumValue - minimumRange \(selectedMaximumValue - minimumRange)")
    //            print("self.xForValue(selectedMaximumValue - minimumRange) \(self.xForValue(selectedMaximumValue - minimumRange))")
    //            print("touchPoint.x \(touchPoint.x)")
    //            print("min(touchPoint.x,self.xForValue(selectedMaximumValue - minimumRange)) \(min(touchPoint.x,self.xForValue(selectedMaximumValue - minimumRange)))")
    //
    //            let right = min(touchPoint.x,self.xForValue(selectedMaximumValue - minimumRange))
    //            print("right \(right)")
    //            let left = max(minimumX, right)
    //            print("left \(left)")
    //            _minThumb.center = CGPointMake(left, _minThumb.center.y)
    //
    //            self.selectedMinimumValue = self.valueForX(_minThumb.center.x)
    //            print("upper value is now \(self.selectedMaximumValue)")
    //            print("lower value is now \(self.selectedMinimumValue)")
    //        }
    //        if _maxThumbOn {
    //            let maximumX = self.xForValue(self.maximumValue)
    //
    //            _maxThumb.center = CGPointMake(min(max(self.xForValue(self.selectedMinimumValue + self.minimumRange), touchPoint.x), maximumX), _maxThumb.center.y)
    //
    //            self.selectedMaximumValue = self.valueForX(_maxThumb.center.x)
    //            print("upper value is now \(self.selectedMaximumValue)")
    //        }
    //        self.setNeedsDisplay()
    //
    //        return true
    //    }
    
    //    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    //        if !_minThumbOn && !_maxThumbOn {
    //            return true
    //        }
    //
    //        let touchPoint = touch.locationInView(self)
    //        if _minThumbOn {
    //            let minimumY = self.yForValue(self.minimumValue)
    //            let right = min(touchPoint.y,self.yForValue(selectedMaximumValue - minimumRange))
    //            let left = max(minimumY, right)
    //            _minThumb.center = CGPointMake(_minThumb.center.x, left)
    //
    //            self.selectedMinimumValue = self.valueForY(_minThumb.center.y)
    //
    //            self.popView.hidden = false
    //            self.popView.center = CGPointMake(self.popView.center.x, _minThumb.center.y)
    //            self.popView.popValue = "\(_minThumb.center.y)"
    //
    //
    //        }
    //        if _maxThumbOn {
    //            let maximumY = self.yForValue(self.maximumValue)
    //
    //            _maxThumb.center = CGPointMake(_maxThumb.center.x, min(max(self.yForValue(self.selectedMinimumValue + self.minimumRange), touchPoint.y), maximumY))
    //
    //            self.selectedMaximumValue = self.valueForY(_maxThumb.center.y)
    //
    //            self.popView.hidden = false
    //            self.popView.center = CGPointMake(self.popView.center.x, _maxThumb.center.y)
    //            self.popView.popValue = "\(_maxThumb.center.y)"
    //        }
    //        self.setNeedsDisplay()
    //
    //        return true
    //    }
    
    //    public var start: Int = 0
    //    public var end: Int = 50
    
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
    
    //    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    //        let touchPoint = touch.locationInView(self)
    //        if CGRectContainsPoint(_minThumb.frame, touchPoint) {
    //            _minThumbOn = true
    //            self.popView.hidden = false
    //            self.popView.center = CGPointMake(self.popView.center.x, _minThumb.center.y)
    //            self.popView.popValue = "\(_minThumb.center.y)"
    //        } else if CGRectContainsPoint(_maxThumb.frame, touchPoint) {
    //            _maxThumbOn = true
    //            self.popView.hidden = false
    //            self.popView.center = CGPointMake(self.popView.center.x, _maxThumb.center.y)
    //            self.popView.popValue = "\(_maxThumb.center.y)"
    //        }
    //        return true
    //    }
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let touchPoint = touch.locationInView(self)
        if CGRectContainsPoint(_minThumb.frame, touchPoint) {
            _minThumbOn = true
        } else if CGRectContainsPoint(_maxThumb.frame, touchPoint) {
            _maxThumbOn = true
        }
        return true
    }
    
    
    //    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    //        if !_minThumbOn && !_maxThumbOn {
    //            return true
    //        }
    //
    //        let touchPoint = touch.locationInView(self)
    //        if _minThumbOn {
    //            let minimumX = self.xForValue(self.minimumValue)
    //            print("minimumX \(minimumX)")
    //            print("selectedMaximumValue \(selectedMaximumValue)")
    //            print("selectedMaximumValue - minimumRange \(selectedMaximumValue - minimumRange)")
    //            print("self.xForValue(selectedMaximumValue - minimumRange) \(self.xForValue(selectedMaximumValue - minimumRange))")
    //            print("touchPoint.x \(touchPoint.x)")
    //            print("min(touchPoint.x,self.xForValue(selectedMaximumValue - minimumRange)) \(min(touchPoint.x,self.xForValue(selectedMaximumValue - minimumRange)))")
    //
    //            let right = min(touchPoint.x,self.xForValue(selectedMaximumValue - minimumRange))
    //            print("right \(right)")
    //            let left = max(minimumX, right)
    //            print("left \(left)")
    //            _minThumb.center = CGPointMake(left, _minThumb.center.y)
    //
    //            self.selectedMinimumValue = self.valueForX(_minThumb.center.x)
    //            print("upper value is now \(self.selectedMaximumValue)")
    //            print("lower value is now \(self.selectedMinimumValue)")
    //        }
    //        if _maxThumbOn {
    //            let maximumX = self.xForValue(self.maximumValue)
    //
    //            _maxThumb.center = CGPointMake(min(max(self.xForValue(self.selectedMinimumValue + self.minimumRange), touchPoint.x), maximumX), _maxThumb.center.y)
    //
    //            self.selectedMaximumValue = self.valueForX(_maxThumb.center.x)
    //            print("upper value is now \(self.selectedMaximumValue)")
    //        }
    //        self.setNeedsDisplay()
    //
    //        return true
    //    }
    
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
        
        // Adjust the minThumb's center
        let minThumbRoundValue = self.getTheRoundValue(Int(self.selectedMinimumValue))
        UIView.animateWithDuration(0.3) { () -> Void in
            self.adjustThumbCenter(self._minThumb, byNewValue: minThumbRoundValue)
        }
        
        self.selectedMinimumValue = minThumbRoundValue
        
        // Adjust the maxThumb's center
        let maxThumbRoundValue = self.getTheRoundValue(Int(self.selectedMaximumValue))
        UIView.animateWithDuration(0.3) { () -> Void in
            self.adjustThumbCenter(self._maxThumb, byNewValue: maxThumbRoundValue)
            
        }
        self.selectedMaximumValue = maxThumbRoundValue
    }
    
    func getTheRoundValue(value: Int) -> CGFloat {
        if value == 0 {
            return 0
        }
        if value % self.step == 0 {
            return CGFloat(value)
        }
        let pre = value / self.step * self.step
        let next = (value / self.step + 1) * self.step
        if (value - pre) < (next - value) {
            return CGFloat(pre)
        } else {
            return CGFloat(next)
        }
    }
    
    public func getPreStepValue(value: CGFloat, byStep step: CGFloat) -> CGFloat {
        return CGFloat(Int(value / step) * Int(step))
    }
    
    public func getNextStepValue(value: CGFloat, byStep step: CGFloat) -> CGFloat {
        return CGFloat((Int(value / step) + 1) * Int(step))
    }
    
    func adjustThumbCenter(thumb: UIView, byNewValue value: CGFloat) {
        let newX = self.xForValue(value)
        thumb.center = CGPointMake(newX, thumb.center.y)
    }
}








