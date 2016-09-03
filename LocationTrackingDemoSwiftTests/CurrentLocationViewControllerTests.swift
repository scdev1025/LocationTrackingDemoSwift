//
//  CurrentLocationViewControllerTests.swift
//  LocationTrackingDemoSwift
//
//  Created by common on 9/3/16.
//  Copyright © 2016 common. All rights reserved.
//

import XCTest
import RealmSwift
import UIKit
@testable import LocationTrackingDemoSwift

class CurrentLocationViewControllerTests: XCTestCase {
    
    var viewContoller:CurrentLocationViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CurrentLocationViewController") as! CurrentLocationViewController
        // force loading subviews and settig outlets
        let _ = viewContoller.view
        viewContoller.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUIOutLetAreSet() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(viewContoller.longitudeLabel, "longitudeLabel should not be nil")
        XCTAssertNotNil(viewContoller.latitudeLabel, "latitudeLabel should not be nil")
        XCTAssertNotNil(viewContoller.addressLabel, "addressLabel should not be nil")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            let realm = try! Realm()
            realm.objects(LocationObject.self)
        }
    }
    
}
