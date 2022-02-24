//
//  GenericListModifierTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import XCTest
import NnListKit

final class GenericListModifierTests: XCTestCase {
    
    func test_addNew_error() {
        let validator = makeValidator(showError: true)
        let sut = makeSUT(validator: validator)
        let exp = expectation(description: "waiting for error...")
        
        sut.addNew { result in
            switch result {
            case .success: XCTFail()
            case .failure: exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_addNew_success() {
        let sut = makeSUT()
        let exp = expectation(description: "waiting for success...")
        
        sut.addNew { result in
            switch result {
            case .success(let list):
                XCTAssertEqual(list.count, 1)
                exp.fulfill()
            case .failure: XCTFail()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_edit_error() {
        let validator = makeValidator(showError: true)
        let sut = makeSUT(validator: validator)
        let exp = expectation(description: "waiting for error...")
        
        sut.edit(makeItem()) { result in
            switch result {
            case .success: XCTFail()
            case .failure: exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_edit_success() {
        let item = makeItem()
        let cache = makeCache([item])
        let newName = "NewName"
        let alerts = makeAlerts(newName)
        let sut = makeSUT(cache: cache, alerts: alerts)
        let exp = expectation(description: "waiting for success...")
        
        sut.edit(item) { result in
            switch result {
            case .success(let list):
                XCTAssertEqual(list.count, 1)
                XCTAssertEqual(list[0].id, item.id)
                XCTAssertEqual(list[0].name, newName)
                exp.fulfill()
            case .failure: XCTFail()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_delete_success() {
        let item = makeItem()
        let cache = makeCache([item])
        let sut = makeSUT(cache: cache)
        let exp = expectation(description: "waiting for success...")
        
        sut.delete(item) { list in
            XCTAssertTrue(list.isEmpty)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }
}


// MARK: - SUT
extension GenericListModifierTests {
    
    func makeSUT(cache: NnListItemCache? = nil,
                 alerts: NnListModifierAlerts? = nil,
                 validator: NnListNameValidator? = nil,
                 file: StaticString = #filePath, line: UInt = #line) ->  GenericListModifier<TestItem> {
        
        let validator = validator ?? MockNnListNameValidator()
        let sut = GenericListModifier<TestItem>(
            cache: cache ?? makeCache(),
            factory: MockNnListItemFactory(),
            alerts: alerts ?? makeAlerts(),
            validator: validator)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    func makeAlerts(_ name: String = "name") -> NnListModifierAlerts {
        
        MockNnListModifierAlerts(name)
    }
    
    func makeCache(_ items: [TestItem] = []) -> MockNnListItemCache {
        
        MockNnListItemCache(items)
    }
    
    func makeValidator(showError: Bool = false) -> MockNnListNameValidator  {
        
        MockNnListNameValidator(showError: showError)
    }
}

// MARK: - Helper Classes
extension GenericListModifierTests {
    
    class MockNnListItemCache: NnListItemCache {
        
        var items: [TestItem]
        
        init(_ items: [TestItem]) {
            self.items = items
        }
        
        func getItems<T>() -> [T] where T: NnListItem {
            items.compactMap { $0 as? T }
        }
    }
    
    class MockNnListItemFactory: NnListItemFactory {

        func makeNewItem<T>(id: T.ID?, name: String) -> T where T: NnListItem {

            let id = id as? String ?? "NewTestId"

            return TestItem(id: id, name: name) as! T
        }
    }
    
    class MockNnListModifierAlerts: NnListModifierAlerts {
        
        private var name = ""
        
        init(_ name: String = "") {
            self.name = name
        }
        
        func showAddAlert(completion: @escaping (String) -> Void) {
            
            completion(name)
        }
        
        func showEditAlert(_ oldName: String,
                           completion: @escaping (String) -> Void) {
            completion(name)
        }
        
        func showDeleteAlert(itemName name: String,
                             completion: @escaping () -> Void) {
            completion()
        }
    }
    
    class MockNnListNameValidator: NnListNameValidator {
        
        let showError: Bool
        
        private var error: Error {
            NSError(domain: "Test", code: 0)
        }
        
        init(showError: Bool = false) {
            self.showError = showError
        }
        
        func validateName(_ name: String) throws {
            if showError { throw error }
        }
    }
}
