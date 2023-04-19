//
//  File.swift
//  SearviceLearnings
//
//  Created by Rahul Rathod on 19/04/2023.
//

import XCTest
@testable import MyProject
import Foundation

class ChukNorrisServiceTests: XCTestCase {
    
    var chuckNorrisService: ChukNorrisService!
    
    override func setUp() {
        super.setUp()
        chuckNorrisService = ChukNorrisService()
    }
    
    override func tearDown() {
        chuckNorrisService = nil
        super.tearDown()
    }
    
    func testFetchData() {
        let expectation = XCTestExpectation(description: "Fetch Chuck Norris joke")
        
        chuckNorrisService.fetchData() { result in
            switch result {
            case .success(let jokeData):
                XCTAssertNotNil(jokeData.value)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

class ChuckNorrisViewTests: XCTestCase {
    
    func testView() {
        let chuckNorrisView = ChuckNorrisView(chuckNorrisService: ChukNorrisService())
        
        XCTAssertTrue(chuckNorrisView.body is VStack)
        XCTAssertEqual(chuckNorrisView.body.children.count, 2)
        
        let firstChild = chuckNorrisView.body.children.first
        
        XCTAssertTrue(firstChild is Text)
        XCTAssertEqual((firstChild as! Text).content, "Loading...")
        
        let secondChild = chuckNorrisView.body.children.last
        
        XCTAssertTrue(secondChild is Button)
        XCTAssertEqual((secondChild as! Button<Text>).label, Text("Get New Joke"))
    }
}

class ChuckNorrisAnotherViewTests: XCTestCase {
    
    func testView() {
        let chuckNorrisAnotherView = ChuckNorrisAnotherView()
        
        XCTAssertTrue(chuckNorrisAnotherView.body is VStack)
        XCTAssertEqual(chuckNorrisAnotherView.body.children.count, 2)
        
        let firstChild = chuckNorrisAnotherView.body.children.first
        
        XCTAssertTrue(firstChild is Text)
        XCTAssertEqual((firstChild as! Text).content, "Press the button, NOW!")
        
        let secondChild = chuckNorrisAnotherView.body.children.last
        
        XCTAssertTrue(secondChild is Button)
        XCTAssertEqual((secondChild as! Button<Text>).label, Text("Get New Joke"))
    }
}
