//
//  Mini_WaferTests.swift
//  Mini WaferTests
//
//  Created by tolu oluwagbemi on 5/21/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import XCTest
@testable import Mini_Wafer

class Mini_WaferTests: XCTestCase {
    
    var vc: ViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = ViewController()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        vc = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAPIConnection() {
        vc.openAPI(url: "https://restcountries.eu/rest/v2/all", params: [:],      completion: { data, response, error in
            assert((response as? HTTPURLResponse)?.statusCode == 200)
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
