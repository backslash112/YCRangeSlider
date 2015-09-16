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
    
    var _minimumRange: CGFloat = 0
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
    public var popValueImage: UIImage? {
        get {
            fatalError("You can not read from this object.")
        }
        set {
            _minPopView.image = newValue
            _maxPopView.image = newValue
        }
    }
    
    public var maxThumbImage: UIImage? {
        get {
            fatalError("You can not read from this object.")
        }
        set {
            _maxThumb.image = newValue
        }
    }
    
    public var minThumbImage: UIImage? {
        get {
            fatalError("You can not read from this object.")
        }
        set {
            _minThumb.image = newValue
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
    
    var _minPopView: YCPopView!
    
    
    var _maxPopView: YCPopView!
    
    
    
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
        self.buildMinThumbView()
        self.buildMaxThumbView()
        self.buildPopView()
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
                stepNumber.font = UIFont.systemFontOfSize(13)
                stepNumber.sizeToFit()
                
                stepNumber.center = CGPointMake(stepLine.center.x - STEP_HEIGHT - 17, stepLine.center.y)
                self.addSubview(stepNumber)
            } else {
                let unitLine: UIView = UIView(frame: CGRectMake(self.frame.width - UNIT_HEIGHT, self._padding + unitHeight * CGFloat(unit), UNIT_HEIGHT, UNIT_WIDTH))
                unitLine.backgroundColor = UIColor.whiteColor()
                self.addSubview(unitLine)
            }
        }
    }
    
    func buildMinThumbView() {
        let bundle = NSBundle(forClass: self.dynamicType)
        _minThumb = UIImageView(image: UIImage(named: "thumb", inBundle: bundle, compatibleWithTraitCollection: nil))
        
        _minThumb.frame = CGRectMake(0, 0, 29.0, 21.0)
        _minThumb.sizeToFit()
        _minThumb.center = CGPointMake(self.frame.width - 46, self.yForValue(self.selectedMinimumValue))
        self.addSubview(_minThumb)
    }
    
    
    func buildMaxThumbView() {
        let bundle = NSBundle(forClass: self.dynamicType)
        _maxThumb = UIImageView(image: UIImage(named: "thumb", inBundle: bundle, compatibleWithTraitCollection: nil))
        _maxThumb.sizeToFit()
        _maxThumb.center = CGPointMake(self.frame.width - 46, self.yForValue(self.selectedMaximumValue))
        self.addSubview(_maxThumb)
    }
    
    func buildPopView() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let image = UIImage(named: "pop-value_bg", inBundle: bundle, compatibleWithTraitCollection: nil)
        _minPopView = YCPopView(image: image)
        _minPopView.popValue = self.maximumValue
        _minPopView.sizeToFit()
        self.addSubview(_minPopView)
        self.updateMinPopView()
        self.adjustPopView(_minPopView, withThumb: _minThumb)
        
        _maxPopView = YCPopView(image: image)
        _maxPopView.popValue = self.minimumValue
        _maxPopView.sizeToFit()
        self.addSubview(_maxPopView)
        self.updateMaxPopView()
        self.adjustPopView(_maxPopView, withThumb: _maxThumb)
    }
    
    // MARK: - Thumb Status
    
    var _minThumbEnable = true
    func doubleTapOnThumb(thumb: UIImageView) {
       self.toggleThumbUsableState(thumb)
    }
    
    func toggleThumbUsableState(thumb: UIImageView) {
        if thumb == _minThumb {
            _minThumbEnable = !_minThumbEnable
            _minThumb.alpha = _minThumbEnable ? 1.0 : 0.3
            _minPopView.alpha = _minThumbEnable ? 1.0 : 0.3
            
//            _minThumb.userInteractionEnabled = true
        } else if thumb == _maxThumb {
            _maxThumb.alpha = _maxThumbEnable ? 0.3 : 1.0
            _maxPopView.alpha = _maxThumbEnable ? 0.3 : 1.0
            _maxThumbEnable = !_maxThumbEnable
            
//            _maxThumb.userInteractionEnabled = false
        }
    }
    
    var _maxThumbEnable = true
//    func doubleTapOnMaxThumb() {
//        self.toggleThumbUsableState(_maxThumb)
//    }
    
    // MARK: - Tracking Touch
    
    var date: NSDate?
    func isDoubleTap() -> Bool {
        return date != nil && date?.dateByAddingTimeInterval(0.2).compare(NSDate()) == NSComparisonResult.OrderedDescending
    }
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let touchPoint = touch.locationInView(self)
        // double tap checking
        
        if CGRectContainsPoint(_minThumb.frame, touchPoint) {
            if self.isDoubleTap() {
                self.doubleTapOnThumb(_minThumb)
                date = nil
            } else {
                date = NSDate()
            }
        } else if CGRectContainsPoint(_maxThumb.frame, touchPoint) {
            if self.isDoubleTap() {
                self.doubleTapOnThumb(_maxThumb)
                date = nil
            }
            else {
                date = NSDate()
            }
        }
        
        if CGRectContainsPoint(_minThumb.frame, touchPoint) && _minThumbEnable {
            if _minThumbEnable {
                _minThumbOn = true
                self.bringSubviewToFront(_minThumb)
                self.adjustPopView(_minPopView, withThumb: _minThumb)
                self.updateMinPopView()
            }
            
        } else if CGRectContainsPoint(_maxThumb.frame, touchPoint) && _maxThumbEnable {
            if _maxThumbEnable {
                _maxThumbOn = true
                self.bringSubviewToFront(_maxThumb)
                self.adjustPopView(_maxPopView, withThumb: _maxThumb)
                self.updateMaxPopView()
            }
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
            self.adjustPopView(_minPopView, withThumb: _minThumb)
            
            if self.isSameValue(self.selectedMaximumValue, secondValue: self.selectedMinimumValue) {
                if _maxThumbEnable {
                    self.toggleThumbUsableState(_maxThumb)
                    _maxThumb.hidden = true
                    print("disalbe max thumb")
                }
            } else {
                if !_maxThumbEnable {
                    self.toggleThumbUsableState(_maxThumb)
                    _maxThumb.hidden = false
                }
            }
        } else if _maxThumbOn {
            _maxThumb.center = CGPointMake(_maxThumb.center.x, min(max(self.yForValue(self.selectedMinimumValue + self.minimumRange), touchPoint.y), self.yForValue(self.maximumValue)))
            self.selectedMaximumValue = self.valueForY(_maxThumb.center.y)
            //            self.showPopView()
            self.updateMaxPopView()
            self.adjustPopView(_maxPopView, withThumb: _maxThumb)
            if self.isSameValue(self.selectedMaximumValue, secondValue: self.selectedMinimumValue)  {
                if _minThumbEnable {
                    self.toggleThumbUsableState(_minThumb)
                    _minThumb.hidden = true
                    print("disalbe min thumb")
                }
            } else {
                if !_minThumbEnable {
                    self.toggleThumbUsableState(_minThumb)
                    _minThumb.hidden = false
                }
            }
        }
        
        self.delegate?.rangeSlider(self, valueChangedWithMinimumValue: self.maximumValue - self.selectedMaximumValue, andMaxiumValue: self.maximumValue - self.selectedMinimumValue)
        return true
    }
    func isSameValue(firstValue: CGFloat, secondValue: CGFloat) -> Bool {
        print("\(round(firstValue)) == \(round(secondValue))")
        return round(firstValue) == round(secondValue)
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
        self.adjustPopView(_minPopView, withThumb: _minThumb, withAnimation: true)
        self.selectedMinimumValue = minThumbRoundValue
        
        // Adjust the maxThumb's location
        var maxThumbRoundValue: CGFloat!
        
        if self.moveThumbByStep {
            maxThumbRoundValue = self.getRoundValue(self.selectedMaximumValue, bySection: self.step)
        } else {
            maxThumbRoundValue = self.getRoundValue(self.selectedMaximumValue, bySection: self.unit)
        }
        self.adjustThumbCenter(_maxThumb, byNewValue: maxThumbRoundValue)
        
        self.adjustPopView(_maxPopView, withThumb:_maxThumb, withAnimation: true)
        
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
        self.updatePopView(_maxPopView, withValue: self.maximumValue - self.selectedMaximumValue + self.minimumValue)
    }
    
    func updateMinPopView() {
        self.updatePopView(_minPopView, withValue:  self.maximumValue - self.selectedMinimumValue + self.minimumValue)
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








