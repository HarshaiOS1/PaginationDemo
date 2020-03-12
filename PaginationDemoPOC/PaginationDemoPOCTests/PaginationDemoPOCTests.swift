//
//  PaginationDemoPOCTests.swift
//  PaginationDemoPOCTests
//
//  Created by Harsha on 10/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import XCTest
@testable import PaginationDemoPOC
var viewContoller: ViewController?
var carModelListViewController: CarModelListViewController?

class PaginationDemoPOCTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        viewContoller = storyBoard.instantiateViewController(withIdentifier: String(describing: ViewController.self)) as? ViewController
        viewContoller?.loadView()
        XCTAssertNotNil(viewContoller, "ViewContoller has failed to create instance")
        _ = viewContoller?.view
        
        carModelListViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: CarModelListViewController.self)) as? CarModelListViewController
        carModelListViewController?.loadView()
        XCTAssertNotNil(carModelListViewController, "CarModelListViewController has failed to create instance")
        _ = carModelListViewController?.view
    }
    
    func testManufactureListResponseAsyncTest() {
        /*
         Mock data with local Json for testing instead direct server hit,
         To reduce load on server in realtime
         */
        let expectation = self.expectation(description: "test json")
        var result: Bool?
        XCTAssertNil(viewContoller?.viewModel.model)
        viewContoller?.viewModel.getManufacturerList(page: 0, completion: { (isSuccess, message) in
            result = isSuccess
            expectation.fulfill()
        })
        waitForExpectations(timeout: 20)
        
        XCTAssertNotNil(viewContoller?.viewModel.model)
        XCTAssertTrue(result ?? false)
        
        //Test if the method return's correct manufacturerCode for manufacturer Brand name
        let firstDataDict = [viewContoller?.viewModel.model?.wkda?.keys.first ?? "" : viewContoller?.viewModel.model?.wkda?.values.first ?? ""]
        
        let manufacturerCode = viewContoller?.viewModel.getManufacturerIDForValue(manufacturerName: viewContoller?.viewModel.model?.wkda?.values.first ?? "")
        XCTAssertEqual(manufacturerCode, (firstDataDict.first?.key))
    }
    
    func testCarListResponseAsyncTest() {
        /*
         Mock data with local Json for testing instead direct server hit,
         To reduce load on server in realtime
         */
        
        //        Manufacturer :"020":"Abarth"
        
        let expectation = self.expectation(description: "test car list api")
        var result: Bool?
        XCTAssertNil(carModelListViewController?.viewModel.model)
        carModelListViewController?.viewModel.getCarModelList(manufacturer: "020", page: 0, completion: { (isSuccess, message) in
            result = isSuccess
            expectation.fulfill()
        })
        waitForExpectations(timeout: 20)
        
        XCTAssertNotNil(carModelListViewController?.viewModel.model)
        
        XCTAssertTrue(result ?? false)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
