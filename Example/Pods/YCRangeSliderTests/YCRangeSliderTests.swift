//
//  YCRangeSliderTests.swift
//  YCRangeSliderTests
//
//  Created by Carl.Yang on 9/14/15.
//
//

import XCTest
import YCRangeSlider

class YCRangeSliderTests: XCTestCase {
    
    //let slider = YCRangeSlider()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        self.slider.self_view_size_width = 10
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testXForValueMethod() {
        let slider = YCRangeSlider()
        slider.self_view_size_width = 500
        slider._padding = 50
        slider.minimumValue = 0
        slider.maximumValue = 100
        
        let value1: CGFloat = 50
        let x1 = slider.xForValue(value1)
        XCTAssertEqual(250, x1)
        let value2: CGFloat = 25
        let x2 = slider.xForValue(value2)
        XCTAssertEqual(150, x2)
    }
    
    func testValueForXMethod() {
        let slider = YCRangeSlider()
        slider.self_view_size_width = 500
        
        slider._padding = 50
        slider.minimumValue = 0
        slider.maximumValue = 100
        
        let x1: CGFloat = 250
        let value1 = slider.valueForX(x1)
        XCTAssertEqual(50, value1)
        
        let x2: CGFloat = 150
        let value2 = slider.valueForX(x2)
        XCTAssertEqual(25, value2)
    }
    
}
