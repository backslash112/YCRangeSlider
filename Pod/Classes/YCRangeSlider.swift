//
//  YCRangeSlider.swift
//  ios-custom-slider-demo
//
//  Created by Carl.Yang on 9/10/15.
//  Copyright © 2015 Yang Cun. All rights reserved.
//

import UIKit

public enum YCRelative {
    case horizontal, vertical
}

public enum YCHorizontalAlignment {
    case left, right
}

public enum YCVerticalAlignment {
    case top, bottom
}

public protocol YCRangeSliderDelegate {
    func rangeSlider(rangeSlider: YCRangeSlider, valueChangedWithMinimumValue minimumValue: CGFloat, andMaxiumValue maxiumValue: CGFloat)
}

public class YCRangeSlider: UIControl {
    
    public var delegate: YCRangeSliderDelegate?
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
    
    var _minimumRange: CGFloat = 10
    public var minimumRange: CGFloat {
        get {
            return _minimumRange
        }
        set {
            _minimumRange = newValue
            self.setNeedsDisplay()
        }
    }
    
    public var minHandle: UIImage!
    public var maxHandle: UIImage!
    var _popViewBackgroundImage: UIImage!
    public var popViewBackgroundImage: UIImage {
        get {
            if _popViewBackgroundImage == nil {
                _popViewBackgroundImage = UIImage(named: "time-machine_popValue_bg")
            }
            return _popViewBackgroundImage
        }
        set {
            _popViewBackgroundImage = newValue
            self.setNeedsDisplay()
        }
    }
    
    public var moveThumbByStep = false
    var _relative: YCRelative = .vertical
    
    public var horizontalAlignment: YCHorizontalAlignment = .left
    public var verticalAlignment: YCVerticalAlignment = .top
    
    var _maxThumbOn = false
    var _minThumbOn = false
    
    public var _padding: CGFloat = 50
    
    var _minThumb: UIImageView!
    var _maxThumb: UIImageView!
    var _track: UIImageView!
    var _trackBackground: UIImageView!
    
    var _popView: YCPopView?
    var popView: YCPopView {
        get {
            if _popView == nil {
                _popView = YCPopView(image: self.popViewBackgroundImage)
                _popView?.popValue = "\(self.maximumValue)"
                _popView?.sizeToFit()
            }
            return _popView!
        }
        
        set {
            _popView = newValue
        }
    }
    
    public func xForValue(value: CGFloat) -> CGFloat {
        return  (self.frame.width - _padding * 2) * (value - minimumValue) / (maximumValue - minimumValue) + _padding
    }
    
    func yForValue(value: CGFloat) -> CGFloat {
        return  (self.frame.height - _padding * 2) * (value - minimumValue) / (maximumValue - minimumValue) + _padding
    }
    
    public func valueForX(x: CGFloat) -> CGFloat {
        return  ((x - _padding) / (self.frame.width - _padding * 2)) * (maximumValue - minimumValue) + minimumValue
    }
    
    func valueForY(y: CGFloat) -> CGFloat {
        return ((y - _padding) / (self.frame.height - _padding * 2)) * (maximumValue - minimumValue) + minimumValue
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        
    }
    
    public convenience init(frame: CGRect, relative: YCRelative, minimumValue: CGFloat, maximumValue: CGFloat, step: CGFloat) {
        self.init(frame: frame)
        
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.selectedMinimumValue = minimumValue
        self.selectedMaximumValue = maximumValue
        self.step = step
        self._relative = relative
        self.buildBaseLine()
        self.buildScales()
        self.buildHandleMinThumbView()
        self.buildHandleMaxThumbView()
        self.buildPopBackgroundView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var step: CGFloat = 10
    public var unit: CGFloat = 1
    
    let UNIT_WIDTH: CGFloat = 1
    let UNIT_HEIGHT: CGFloat = 10
    let STEP_HEIGHT: CGFloat = 15
    
    func buildBaseLine() {
        if self._relative == YCRelative.horizontal {
            // Draw the base line
            let lineHeight: CGFloat = 1
            let lineWidth: CGFloat = self.frame.width - _padding * 2
            let line = UIView(frame: CGRectMake(0, 0, lineWidth, lineHeight))
            line.center = self.center
            line.backgroundColor = UIColor.whiteColor()
            self.addSubview(line)
        } else {
            // Draw the base line
            let lineWidth: CGFloat = 1
            let lineHeight: CGFloat = self.frame.height - _padding * 2
            let line = UIView(frame: CGRectMake(0, 0, lineWidth, lineHeight))
            line.center = self.center
            line.backgroundColor  = UIColor.whiteColor()
            self.addSubview(line)
        }
    }
    
    func buildScales() {
        if self._relative == YCRelative.horizontal {
            
            // Draw the base scales
            let lineWidth: CGFloat = self.frame.width - _padding * 2
            let unitWidth = lineWidth / CGFloat((maximumValue - minimumValue))
            for unit in 0...Int(maximumValue - minimumValue) {
                if CGFloat(unit) % step == 0 { // Add step to the base line
                    let stepLine: UIView = UIView(frame: CGRectMake(
                        _padding + unitWidth * CGFloat(unit),
                        self.center.y - STEP_HEIGHT,
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
                    
                } else {
                    let unitLine: UIView = UIView(frame: CGRectMake(
                        _padding + unitWidth * CGFloat(unit),
                        self.center.y - UNIT_HEIGHT,
                        UNIT_WIDTH,
                        UNIT_HEIGHT))
                    
                    unitLine.backgroundColor = UIColor.whiteColor()
                    self.addSubview(unitLine)
                }
            }
        } else {
            
            // Draw the base scales
            let lineWidth: CGFloat = 1
            let lineHeight: CGFloat = self.frame.height - _padding * 2
            let line = UIView(frame: CGRectMake(0, 0, lineWidth, lineHeight))
            line.center = self.center
            line.backgroundColor  = UIColor.whiteColor()
            self.addSubview(line)
            
            let unitHeight = lineHeight / CGFloat((maximumValue - minimumValue))
            for unit in 0...Int(maximumValue - minimumValue) {
                print("unit \(unit)")
                if CGFloat(unit) % self.step == 0 {
                    let stepLine: UIView = UIView(frame: CGRectMake(
                        line.center.x - STEP_HEIGHT,
                        self.frame.height - self._padding - unitHeight * CGFloat(unit),
                        STEP_HEIGHT,
                        UNIT_WIDTH))
                    stepLine.backgroundColor = UIColor.whiteColor()
                    self.addSubview(stepLine)
                    
                    let stepNumber: UILabel = UILabel()
                    stepNumber.text = "\(unit)"
                    stepNumber.textColor = UIColor.whiteColor()
                    stepNumber.font = UIFont.systemFontOfSize(10)
                    stepNumber.sizeToFit()
                    
                    stepNumber.center = CGPointMake(stepLine.center.x - STEP_HEIGHT, stepLine.center.y)
                    self.addSubview(stepNumber)
                } else {
                    let unitLine: UIView = UIView(frame: CGRectMake(line.center.x - UNIT_HEIGHT, self._padding + unitHeight * CGFloat(unit), UNIT_HEIGHT, UNIT_WIDTH))
                    unitLine.backgroundColor = UIColor.whiteColor()
                    self.addSubview(unitLine)
                }
            }
        }
    }
    
    func buildHandleMinThumbView() {
        if self._relative == YCRelative.horizontal {
            _minThumb = UIImageView(image: UIImage(named: "handle"))
            _minThumb.sizeToFit()
            _minThumb.center = CGPointMake(self.xForValue(self.selectedMinimumValue), ((self.frame.height - STEP_HEIGHT)) / 2 - STEP_HEIGHT - 20)
            self.addSubview(_minThumb)
        } else {
            _minThumb = UIImageView(image: UIImage(named: "handle_vertical_left"))
            _minThumb.sizeToFit()
            _minThumb.center = CGPointMake(((self.frame.width - STEP_HEIGHT)) / 2 - STEP_HEIGHT - 20, self.yForValue(self.selectedMinimumValue))
            self.addSubview(_minThumb)
        }
    }
    
    func buildHandleMaxThumbView() {
        if self._relative == YCRelative.horizontal {
            _maxThumb = UIImageView(image: UIImage(named: "handle"))
            _maxThumb.sizeToFit()
            _maxThumb.center = CGPointMake(self.xForValue(self.selectedMaximumValue), ((self.frame.height - STEP_HEIGHT)) / 2 - STEP_HEIGHT - 20)
            self.addSubview(_maxThumb)
        } else {
            _maxThumb = UIImageView(image: UIImage(named: "handle_vertical_left"))
            _maxThumb.sizeToFit()
            _maxThumb.center = CGPointMake(((self.frame.width - STEP_HEIGHT)) / 2 - STEP_HEIGHT - 20, self.yForValue(self.selectedMaximumValue))
            self.addSubview(_maxThumb)
        }
    }
    
    func buildPopBackgroundView() {
        if _relative == YCRelative.horizontal {
            self.popView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
        self.addSubview(self.popView)
        self.popView.hidden = true
    }
    
    // MARK: - Tracking Touch
    
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let touchPoint = touch.locationInView(self)
        if CGRectContainsPoint(_minThumb.frame, touchPoint) {
            _minThumbOn = true
            self.adjustPopViewWithThumb(_minThumb)
            self.showPopView()
            self.updatePopViewValue(self.selectedMinimumValue)
            
        } else if CGRectContainsPoint(_maxThumb.frame, touchPoint) {
            _maxThumbOn = true
            self.adjustPopViewWithThumb(_maxThumb)
            self.showPopView()
            self.updatePopViewValue(self.selectedMaximumValue)
            
        }
        return true
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if !_maxThumbOn && !_minThumbOn {
            return true
        }
        let touchPoint = touch.locationInView(self)
        
        if self._relative == YCRelative.horizontal {
            if _minThumbOn {
                _minThumb.center = CGPointMake(max(self.xForValue(self.minimumValue), min(touchPoint.x, self.xForValue(self.selectedMaximumValue - self._minimumRange))), _minThumb.center.y)
                self.selectedMinimumValue = self.valueForX(_minThumb.center.x)
                self.showPopView()
                self.updatePopViewValue(self.selectedMinimumValue)
                self.adjustPopViewWithThumb(_minThumb)
            }
            if _maxThumbOn {
                _maxThumb.center = CGPointMake(min(max(self.xForValue(self.selectedMinimumValue + self._minimumRange), touchPoint.x), self.xForValue(self.maximumValue)), _maxThumb.center.y)
                self.selectedMaximumValue = self.valueForX(_maxThumb.center.x)
                self.showPopView()
                self.updatePopViewValue(self.selectedMaximumValue)
                self.adjustPopViewWithThumb(_maxThumb)
            }
        } else {
            if _minThumbOn {
                _minThumb.center = CGPointMake(_minThumb.center.x, max(self.yForValue(self.minimumValue), min(touchPoint.y, self.yForValue(self.selectedMaximumValue - self._minimumRange))))
                self.selectedMinimumValue = self.valueForY(_minThumb.center.y)
                self.showPopView()
                self.updatePopViewValue(self.selectedMinimumValue)
                self.adjustPopViewWithThumb(_minThumb)
            }
            if _maxThumbOn {
                _maxThumb.center = CGPointMake(_maxThumb.center.x, min(max(self.yForValue(self.selectedMinimumValue + self._minimumRange), touchPoint.y), self.yForValue(self.maximumValue)))
                self.selectedMaximumValue = self.valueForY(_maxThumb.center.y)
                self.showPopView()
                self.updatePopViewValue(self.selectedMaximumValue)
                self.adjustPopViewWithThumb(_maxThumb)
            }
        }
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        _maxThumbOn = false
        _minThumbOn = false
        
        // Adjust the minThumb's location
        var minThumbRoundValue:  CGFloat!
        if self.moveThumbByStep {
            minThumbRoundValue  = self.getRoundValue(self.selectedMinimumValue, bySection: self.step)
        } else {
            minThumbRoundValue  = self.getRoundValue(self.selectedMinimumValue, bySection: self.unit)
        }
        self.adjustThumbCenter(_minThumb, byNewValue: minThumbRoundValue)
        
        self.adjustPopViewWithThumb(_minThumb, withAnimation: true)
        self.hidePopView()
        
        self.selectedMinimumValue = minThumbRoundValue
        
        // Adjust the maxThumb's location
        var maxThumbRoundValue: CGFloat!
        
        if self.moveThumbByStep {
            maxThumbRoundValue = self.getRoundValue(self.selectedMaximumValue, bySection: self.step)
        } else {
            maxThumbRoundValue = self.getRoundValue(self.selectedMaximumValue, bySection: self.unit)
        }
        self.adjustThumbCenter(_maxThumb, byNewValue: maxThumbRoundValue)
        
        self.adjustPopViewWithThumb(_maxThumb, withAnimation: true)
        self.hidePopView()
        
        self.selectedMaximumValue = maxThumbRoundValue
        
        if _relative == YCRelative.horizontal {
            self.delegate?.rangeSlider(self, valueChangedWithMinimumValue: selectedMinimumValue, andMaxiumValue: self.selectedMaximumValue)
        } else {
            self.delegate?.rangeSlider(self, valueChangedWithMinimumValue: self.maximumValue - self.selectedMaximumValue, andMaxiumValue: self.maximumValue - self.selectedMinimumValue)
        }
    }
    
    /*
    Get the round value by section.
    e.g. if the section is 5, then the value must be 0, 5, 10, 15; if the section is 3, then the value must be 0, 3, 6, 9, 12
    */
    func getRoundValue(value: CGFloat, bySection section: CGFloat) -> CGFloat {
        if value == 0 {
            return 0
        }
        if value % section == 0 {
            return CGFloat(value)
        }
        let pre = CGFloat(Int(value)) / section * section
        let next = (value / section + 1) * section
        if (value - pre) < (next - value) {
            return CGFloat(pre)
        } else {
            return CGFloat(next)
        }
    }
    
    func adjustThumbCenter(thumb: UIView, byNewValue value: CGFloat) {
        if self._relative == YCRelative.horizontal {
            let newX = self.xForValue(value)
            UIView.animateWithDuration(0.3) { () -> Void in
                thumb.center = CGPointMake(newX, thumb.center.y)
            }
        } else {
            let newY = self.yForValue(value)
            UIView.animateWithDuration(0.3) { () -> Void in
                thumb.center = CGPointMake(thumb.center.x, newY)
            }
        }
    }
    
    func showPopView() {
        self.popView.hidden = false
    }
    
    func updatePopViewValue(value: CGFloat) {
        print("value: \(value)")
        let roundValue = self.getRoundValue(value, bySection: self.unit)
        print("roundValue: \(roundValue)")
        self.popView.popValue = "\(roundValue)"
    }
    func hidePopView() {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.popView.hidden = true
        }
    }
    
    func adjustPopViewWithThumb(thumb: UIView, withAnimation animation: Bool = false) {
        
        if _relative == YCRelative.horizontal {
            UIView.animateWithDuration(animation ? 0.3 : 0.0) { () -> Void in
                self.popView.center = CGPointMake(thumb.center.x,
                    thumb.center.y - self.popView.frame.height / 2 - thumb.frame.height / 2)
            }

        } else {
            UIView.animateWithDuration(animation ? 0.3 : 0.0) { () -> Void in
                self.popView.center = CGPointMake(thumb.frame.origin.x - self.popView.frame.width / 2, thumb.center.y)
            }
        }
    }
}








