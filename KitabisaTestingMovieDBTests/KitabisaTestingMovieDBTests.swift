//
//  KitabisaTestingMovieDBTests.swift
//  KitabisaTestingMovieDBTests
//
//  Created by Michael Louis on 09/03/21.
//
@testable import KitabisaTestingMovieDB

import XCTest

class KitabisaTestingMovieDBTests: XCTestCase {

    var viewController: ViewController!
    var detailVC : DetailViewController!
    
    override func setUpWithError() throws {
        
        super.setUp()
        viewController = ViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        super.tearDown()
        viewController = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        //Test klo berhasil fetch movies
        XCTAssertNotNil(viewController.arrayMovies)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
