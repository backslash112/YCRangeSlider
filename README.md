# YCRangeSlider

[![CI Status](http://img.shields.io/travis/backslash112/YCRangeSlider.svg?style=flat)](https://travis-ci.org/backslash112/YCRangeSlider)
[![Version](https://img.shields.io/cocoapods/v/YCRangeSlider.svg?style=flat)](http://cocoapods.org/pods/YCRangeSlider)
[![License](https://img.shields.io/cocoapods/l/YCRangeSlider.svg?style=flat)](http://cocoapods.org/pods/YCRangeSlider)
[![Platform](https://img.shields.io/cocoapods/p/YCRangeSlider.svg?style=flat)](http://cocoapods.org/pods/YCRangeSlider)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YCRangeSlider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YCRangeSlider', '0.1.0'
```

## Usage
(see sample Xcode project in /Example)
```Swift
let slider = YCRangeSlider

// Setup the Values
slider.minimumValue = 0
slider.selectedMinimumValue = 0
slider.maximumValue = 500
slider.selectedMaximumValue = 500
slider.minimumRange = 1

// Configure custom interface
slider.barBackground = UIImage(named: "tm_bar-background")
slider.minHandle = UIImage(named: "tm_handle_start")
slider.maxHandle = UIImage(named: "tm_handle_end")
slider.popViewBackgroundImage = UIImage(named: "time-machine_popValue_bg")

let height: CGFloat = 463
let width: CGFloat = 133
slider.initWithFrame2(frame: CGRectMake((self.view.frame.width-width)/2, (self.view.frame.height - height)/2, width, height))
self.view.addSubview(slider)
```

## Author

Yang Cun, yangcun@live.com

## License

YCRangeSlider is available under the MIT license. See the LICENSE file for more info.
