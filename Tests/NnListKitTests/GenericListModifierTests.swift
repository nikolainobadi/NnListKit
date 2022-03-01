////
////  GenericListModifierTests.swift
////  
////
////  Created by Nikolai Nobadi on 2/23/22.
////
//
//import XCTest
//import NnListKit
//
//final class GenericListModifierTests: XCTestCase {
//    
//    func test_addNew_error() {
//        let validator = makeValidator(.addModError)
//        let sut = makeSUT(validator: validator)
//        let exp = expectation(description: "waiting for error...")
//        
//        sut.addNew { result in
//            switch result {
//            case .success: XCTFail()
//            case .failure: exp.fulfill()
//            }
//        }
//        
//        waitForExpectations(timeout: 0.1)
//    }
//    
//    func test_addNew_success() {
//        let sut = makeSUT()
//        let exp = expectation(description: "waiting for success...")
//        
//        sut.addNew { result in
//            switch result {
//            case .success(let list):
//                XCTAssertEqual(list.count, 1)
//                exp.fulfill()
//            case .failure: XCTFail()
//            }
//        }
//        
//        waitForExpectations(timeout: 0.1)
//    }
//    
//    func test_edit_error() {
//        let validator = makeValidator(.editModError)
//        let sut = makeSUT(validator: validator)
//        let exp = expectation(description: "waiting for error...")
//        
//        sut.edit(makeItem()) { result in
//            switch result {
//            case .success: XCTFail()
//            case .failure: exp.fulfill()
//            }
//        }
//        
//        waitForExpectations(timeout: 0.1)
//    }
//    
//    func test_edit_success() {
//        let item = makeItem()
//        let cache = makeCache([item])
//        let newName = "NewName"
//        let alerts = makeAlerts(newName)
//        let sut = makeSUT(cache: cache, alerts: alerts)
//        let exp = expectation(description: "waiting for success...")
//        
//        sut.edit(item) { result in
//            switch result {
//            case .success(let list):
//                XCTAssertEqual(list.count, 1)
//                XCTAssertEqual(list[0].id, item.id)
//                XCTAssertEqual(list[0].name, newName)
//                exp.fulfill()
//            case .failure: XCTFail()
//            }
//        }
//        
//        waitForExpectations(timeout: 0.1)
//    }
//    
//    func test_delete_success() {
//        let item = makeItem()
//        let cache = makeCache([item])
//        let sut = makeSUT(cache: cache)
//        let exp = expectation(description: "waiting for success...")
//        
//        sut.delete(item) { list in
//            XCTAssertTrue(list.isEmpty)
//            exp.fulfill()
//        }
//        
//        waitForExpectations(timeout: 0.1)
//    }
//}
//
//
//// MARK: - SUT
//extension GenericListModifierTests {
//    
//    func makeSUT(cache: NnListItemCache? = nil,
//                 alerts: NnListModifierAlerts? = nil,
//                 validator: NnListNameValidator? = nil,
//                 file: StaticString = #filePath, line: UInt = #line) ->  GenericListModifier<TestItem> {
//        
//        let validator = validator ?? MockNnListNameValidator()
//        let sut = makeModifier(
//            cache: cache ?? makeCache(),
//            factory: MockNnListItemFactory(),
//            alerts: alerts ?? makeAlerts(),
//            validator: validator)
//        
//        trackForMemoryLeaks(sut, file: file, line: line)
//        
//        return sut
//    }
//}
