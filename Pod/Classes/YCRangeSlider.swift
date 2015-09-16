//
//  YCRangeSlider.swift
//  ios-custom-slider-demo
//
//  Created by Carl.Yang on 9/10/15.
//  Copyright © 2015 Yang Cun. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    var _minimumRange: CGFloat = 1
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
                let bundle = NSBundle(forClass: self.dynamicType)
                _popViewBackgroundImage = UIImage(named: "pop-value_bg", inBundle: bundle, compatibleWithTraitCollection: nil)
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
    
    var _minPopView: YCPopView?
    var minPopView: YCPopView {
        get {
            if _minPopView == nil {
                _minPopView = YCPopView(image: self.popViewBackgroundImage)
                _minPopView?.popValue = self.maximumValue
                _minPopView?.sizeToFit()
            }
            return _minPopView!
        }
        
        set {
            _minPopView = newValue
        }
    }
    
    var _maxPopView: YCPopView?
    var maxPopView: YCPopView {
        get {
            if _maxPopView == nil {
                _maxPopView = YCPopView(image: self.popViewBackgroundImage)
                _maxPopView?.popValue = self.maximumValue
                _maxPopView?.sizeToFit()
            }
            return _maxPopView!
        }
        
        set {
            _maxPopView = newValue
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
    let STEP_HEIGHT: CGFloat = 0
    
    var viewCenter: CGPoint {
        get {
            return CGPointMake(self.bounds.width / 2, self.bounds.height / 2)
        }
    }
    
    func buildBaseLine() {
        
        print("width: \(self.frame.width) height: \(self.frame.height)")
        // Draw the base line
        let lineWidth: CGFloat = 1
        let lineHeight: CGFloat = self.frame.height - _padding * 2
        let line = UIView(frame: CGRectMake(0, 0, lineWidth, lineHeight))
        line.center = CGPointMake(self.frame.width, viewCenter.y)
        line.backgroundColor  = UIColor.whiteColor()
        self.addSubview(line)
    }
    
    func buildScales() {
        
        
        // Draw the base scales
        let lineHeight: CGFloat = self.frame.height - _padding * 2
        
        
        let unitHeight = lineHeight / CGFloat((maximumValue - minimumValue))
        for unit in 0...Int(maximumValue - minimumValue) {
            print("unit \(unit)")
            if CGFloat(unit) % self.step == 0 {
                let stepLine: UIView = UIView(frame: CGRectMake(
                    self.frame.width - STEP_HEIGHT,
                    self.frame.height - self._padding - unitHeight * CGFloat(unit),
                    STEP_HEIGHT,
                    UNIT_WIDTH))
                stepLine.backgroundColor = UIColor.whiteColor()
                //self.addSubview(stepLine)
                
                let stepNumber: UILabel = UILabel()
                stepNumber.text = "\(Int(minimumValue) + unit)"
                stepNumber.textColor = UIColor.whiteColor()
                stepNumber.font = UIFont.systemFontOfSize(12)
                stepNumber.sizeToFit()
                
                stepNumber.center = CGPointMake(stepLine.center.x - STEP_HEIGHT - 20, stepLine.center.y)
                self.addSubview(stepNumber)
            } else {
                let unitLine: UIView = UIView(frame: CGRectMake(self.frame.width - UNIT_HEIGHT, self._padding + unitHeight * CGFloat(unit), UNIT_HEIGHT, UNIT_WIDTH))
                unitLine.backgroundColor = UIColor.whiteColor()
                self.addSubview(unitLine)
            }
        }
    }
    
    func buildHandleMinThumbView() {
        //handle_vertical_left
        let bundle = NSBundle(forClass: self.dynamicType)
        _minThumb = UIImageView(image: UIImage(named: "thumb", inBundle: bundle, compatibleWithTraitCollection: nil))
        
        _minThumb.frame = CGRectMake(0, 0, 29.0, 21.0)
        _minThumb.sizeToFit()
        _minThumb.center = CGPointMake(self.frame.width - 50, self.yForValue(self.selectedMinimumValue))
        self.addSubview(_minThumb)
//        _minThumb.backgroundColor = UIColor.greenColor()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTapOnMinThumb")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.cancelsTouchesInView = false
        _minThumb.addGestureRecognizer(doubleTap)
//        _minThumb.userInteractionEnabled = true
    }
    
    var minThumbEnable = true
    
    func singleTapOnMinThumb() {
        
    }
    func doubleTapOnMinThumb() {
        print("doubleTapOnMinThumb")
        minThumbEnable = !minThumbEnable
        
        _minThumb.alpha = minThumbEnable ? 1.0 : 0.3
        self.minPopView.alpha = minThumbEnable ? 1.0 : 0.3
    }
    
    func buildHandleMaxThumbView() {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        _maxThumb = UIImageView(image: UIImage(named: "thumb.png", inBundle: bundle, compatibleWithTraitCollection: nil))
        _maxThumb.sizeToFit()
        _maxThumb.center = CGPointMake(self.frame.width - 50, self.yForValue(self.selectedMaximumValue))
        self.addSubview(_maxThumb)
//        _maxThumb.backgroundColor = UIColor.redColor()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTapOnMaxThumb")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.cancelsTouchesInView = false
        _maxThumb.addGestureRecognizer(doubleTap)
//        _maxThumb.userInteractionEnabled = true

    }
    
    var maxThumbEnable = true
    func doubleTapOnMaxThumb() {
        print("doubleTapOnMaxThumb")

        _maxThumb.alpha = maxThumbEnable ? 0.3 : 1.0
        self.maxPopView.alpha = maxThumbEnable ? 0.3 : 1.0
        maxThumbEnable = !maxThumbEnable
    }
    
    func buildPopBackgroundView() {
        
        self.addSubview(self.minPopView)
        self.updateMinPopView()
        self.adjustPopView(self.minPopView, withThumb: _minThumb)
        
        self.addSubview(self.maxPopView)
        self.updateMaxPopView()
        self.adjustPopView(self.maxPopView, withThumb: _maxThumb)
        
    }
    
    // MARK: - Tracking Touch
    
    var date: NSDate?
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let touchPoint = touch.locationInView(self)

        // double tap checking
        let now = NSDate()
        if date != nil && date?.dateByAddingTimeInterval(0.5).compare(now) == NSComparisonResult.OrderedDescending {
            print("go!")
            date = nil

            if CGRectContainsPoint(_minThumb.frame, touchPoint) {
                self.doubleTapOnMinThumb()
            } else if CGRectContainsPoint(_maxThumb.frame, touchPoint) {
                self.doubleTapOnMaxThumb()
            }
        } else {
            date = now
            print("......")
        }
        
        if CGRectContainsPoint(_minThumb.frame, touchPoint) && minThumbEnable {
            _minThumbOn = true
            self.bringSubviewToFront(_minThumb)
            self.adjustPopView(self.minPopView, withThumb: _minThumb)
            //            self.showPopView()
            self.updateMinPopView()
            
            
        } else if CGRectContainsPoint(_maxThumb.frame, touchPoint) && maxThumbEnable {
            _maxThumbOn = true
            self.bringSubviewToFront(_maxThumb)
            self.adjustPopView(self.maxPopView, withThumb: _maxThumb)
            //            self.showPopView()
            self.updateMaxPopView()
            
        }
        return true
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if !_maxThumbOn && !_minThumbOn {
            return true
        }
        let touchPoint = touch.locationInView(self)
        
        
        if _minThumbOn {
            _minThumb.center = CGPointMake(_minThumb.center.x, max(self.yForValue(self.minimumValue), min(touchPoint.y, self.yForValue(self.selectedMaximumValue - self.minimumRange))))
            self.selectedMinimumValue = self.valueForY(_minThumb.center.y)
            //            self.showPopView()
            self.updateMinPopView()
            self.adjustPopView(self.minPopView, withThumb: _minThumb)
            
            if _minThumb.center == _maxThumb.center {
                flag = 2
            }
        } else if _maxThumbOn {
            _maxThumb.center = CGPointMake(_maxThumb.center.x, min(max(self.yForValue(self.selectedMinimumValue + self.minimumRange), touchPoint.y), self.yForValue(self.maximumValue)))
            self.selectedMaximumValue = self.valueForY(_maxThumb.center.y)
            //            self.showPopView()
            self.updateMaxPopView()
            self.adjustPopView(self.maxPopView, withThumb: _maxThumb)
            
            if _maxThumb.center == _minThumb.center {
                flag = 1
            }
        }
        
            self.delegate?.rangeSlider(self, valueChangedWithMinimumValue: self.maximumValue - self.selectedMaximumValue, andMaxiumValue: self.maximumValue - self.selectedMinimumValue)
        return true
    }
    
    var flag = 0 // 1:max 2:min
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
        
        self.adjustPopView(self.minPopView, withThumb: _minThumb, withAnimation: true)
        
        self.selectedMinimumValue = minThumbRoundValue
        
        // Adjust the maxThumb's location
        var maxThumbRoundValue: CGFloat!
        
        if self.moveThumbByStep {
            maxThumbRoundValue = self.getRoundValue(self.selectedMaximumValue, bySection: self.step)
        } else {
            maxThumbRoundValue = self.getRoundValue(self.selectedMaximumValue, bySection: self.unit)
        }
        self.adjustThumbCenter(_maxThumb, byNewValue: maxThumbRoundValue)
        
        self.adjustPopView(self.maxPopView, withThumb:_maxThumb, withAnimation: true)
        
        self.selectedMaximumValue = maxThumbRoundValue
        
        self.delegate?.rangeSlider(self, valueChangedWithMinimumValue: self.maximumValue - self.selectedMaximumValue, andMaxiumValue: self.maximumValue - self.selectedMinimumValue)
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
        let pre = CGFloat(round(value)) / section * section
        let next = (value / section + 1) * section
        if (value - pre) < (next - value) {
            return CGFloat(pre)
        } else {
            return CGFloat(next)
        }
    }
    
    func adjustThumbCenter(thumb: UIView, byNewValue value: CGFloat) {
        
        let newY = self.yForValue(value)
        UIView.animateWithDuration(0.3) { () -> Void in
            thumb.center = CGPointMake(thumb.center.x, newY)
        }
    }
    
    //    func showPopView() {
    //        self.popView.hidden = false
    //    }
    //
    
    func updateMaxPopView() {
        self.updatePopView(self.maxPopView, withValue: self.maximumValue - self.selectedMaximumValue + self.minimumValue)
    }
    
    func updateMinPopView() {
        self.updatePopView(self.minPopView, withValue:  self.maximumValue - self.selectedMinimumValue + self.minimumValue)
    }
    
    func updatePopView(popView: YCPopView, withValue value: CGFloat) {
        let roundValue = self.getRoundValue(value, bySection: self.unit)
        if popView.popValue != roundValue {
            popView.popValue = roundValue
            AudioServicesPlaySystemSound(1306)
        }
    }
    func hidePopView() {
        //        UIView.animateWithDuration(0.3) { () -> Void in
        //            self.popView.hidden = true
        //        }
    }
    
    func adjustPopView(popView: YCPopView, withThumb thumb: UIView, withAnimation animation: Bool = false) {

        UIView.animateWithDuration(animation ? 0.3 : 0.0) { () -> Void in
            popView.center = CGPointMake(thumb.frame.origin.x - popView.frame.width / 2, thumb.center.y)
        }
    }
}








