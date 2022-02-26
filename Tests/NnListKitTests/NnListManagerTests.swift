//
//  NnListManagerTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import XCTest
import NnListKit

final class NnListManagerTests: XCTestCase {
    
    // MARK: Init Tests
    func test_init_alertsEmpty() {
        let (_, alerts, _) = makeSUT()
    
        XCTAssertNil(alerts.error)
    }
    
    
    // MARK: Add Tests
    func test_addNew_policyError() {
        let policy = makePolicy(error: .addError)
        let (sut, alerts, _) = makeSUT(policy: policy)
        
        expectError(.addError, from: alerts) {
            sut.addNew()
        }
    }
    
    func test_addNew_modifierError() {
        let (sut, alerts, _) = makeSUT(modError: .addModError)
        
        expectError(.addModError, from: alerts) {
            sut.addNew()
        }
    }
    
    func test_addNew_remoteError() {
        let (sut, alerts, remote) = makeSUT()
        
        expectError(.remoteError, from: alerts) {
            sut.addNew()
            remote.complete(with: .remoteError)
        }
    }
    
    func test_addNew_success() {
        let (sut, alerts, remote) = makeSUT()
        
        expectError(nil, from: alerts) {
            sut.addNew()
            remote.complete(with: nil)
        }
    }
    
    
    // MARK: Edit Tests
    func test_edit_policyError() {
        let item = makeItem()
        let policy = makePolicy(error: .editError)
        let cache = makeCache([item])
        let (sut, alerts, _) = makeSUT(policy: policy,
                                       cache: cache)

        expectError(.editError, from: alerts) {
            sut.edit(item)
        }
    }
    
    func test_edit_modifierError() {
        let item = makeItem()
        let cache = makeCache([item])
        let (sut, alerts, _) = makeSUT(modError: .editModError,
                                       cache: cache)

        expectError(.editModError, from: alerts) {
            sut.edit(item)
        }
    }
    
    func test_edit_remoteError() {
        let item = makeItem()
        let cache = makeCache([item])
        let (sut, alerts, remote) = makeSUT(cache: cache)

        expectError(.remoteError, from: alerts) {
            sut.edit(item)
            remote.complete(with: .remoteError)
        }
    }
    
    func test_edit_success() {
        let item = makeItem()
        let cache = makeCache([item])
        let (sut, alerts, remote) = makeSUT(cache: cache)

        expectError(nil, from: alerts) {
            sut.edit(item)
            remote.complete(with: nil)
        }
    }
    
    
    // MARK: Delete Tests
    func test_delete_policyError() {
        let item = makeItem()
        let policy = makePolicy(error: .deleteError)
        let cache = makeCache([item])
        let (sut, alerts, _) = makeSUT(policy: policy,
                                       cache: cache)

        expectError(.deleteError, from: alerts) {
            sut.delete(item)
        }
    }
    
    func test_delete_remoteError() {
        let item = makeItem()
        let cache = makeCache([item])
        let (sut, alerts, remote) = makeSUT(cache: cache)

        expectError(.remoteError, from: alerts) {
            sut.delete(item)
            remote.complete(with: .remoteError)
        }
    }
    
    func test_delete_success() {
        let item = makeItem()
        let cache = makeCache([item])
        let (sut, alerts, remote) = makeSUT(cache: cache)

        expectError(nil, from: alerts) {
            sut.delete(item)
            remote.complete(with: nil)
        }
    }
    
    
    // MARK: Other
    func test_uploadReorderedList_remoteError() {
        let item = makeItem()
        let (sut, alerts, remote) = makeSUT()

        expectError(.remoteError, from: alerts) {
            sut.uploadReorderedList([item])
            remote.complete(with: .remoteError)
        }
    }
    
    func test_uploadReorderedList_success() {
        let item = makeItem()
        let (sut, alerts, remote) = makeSUT()

        expectError(nil, from: alerts) {
            sut.uploadReorderedList([item])
            remote.complete(with: nil)
        }
    }
}


// MARK: - Assertion Helpers
extension NnListManagerTests {
    
    func expectError(_ expectedError: TestError?,
                     from alerts: MockNnListManagerAlerts,
                     when action: (() -> Void)? = nil,
                     file: StaticString = #filePath, line: UInt = #line) {
        action?()
        
        guard let expectedError = expectedError else {
            return XCTAssertNil(alerts.error, "expected no error but recieved one", file: file, line: line)
        }

        guard let error = alerts.error else {
            return XCTFail("no error recieved", file: file, line: line)
        }
        
        guard let testError = error as? TestError else {
            return XCTFail("unexpected error")
        }
        
        XCTAssertEqual(testError, expectedError)
    }
}


// MARK: - SUT
extension NnListManagerTests {
    
    func makeSUT(policy: NnListPolicy? = nil,
                 modError: TestError? = nil,
                 cache: NnListItemCache? = nil,
                 file: StaticString = #filePath,
                 line: UInt = #line) -> (sut: NnListManager<TestItem>, alerts: MockNnListManagerAlerts, remote: NnListRemoteAPISpy) {
        
        let alerts = MockNnListManagerAlerts()
        let spy = NnListRemoteAPISpy()
        let modifier = makeTestModifier(modError: modError,
                                        cache: cache)
        
        let sut = NnListManager<TestItem>(
            policy: policy ?? makePolicy(),
            alerts: alerts,
            remote: spy.makeRemote(),
            modifier: modifier)

        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts, spy)
    }
    
    func makeTestModifier(modError: TestError? = nil,
                          cache: NnListItemCache? = nil) -> GenericListModifier<TestItem> {
        
        makeModifier(cache: cache,
                     validator: makeValidator(modError))
    }
    
    func makePolicy(error: TestError? = nil) -> NnListPolicy {
        MockNnListPolicy(error: error)
    }
}


// MARK: - Helper Classes
extension NnListManagerTests {
    
    class MockNnListPolicy: NnListPolicy {
        
        let error: TestError?
        
        init(error: TestError? = nil) {
            self.error = error
        }
        
        func verifyCanAdd() throws {
            if let error = error {
                throw error
            }
        }
        
        func verifyCanEdit() throws {
            if let error = error {
                throw error
            }
        }
    }
    
    class MockNnListManagerAlerts: NnListManagerAlerts {
        
        var error: Error?
        
        func showError(_ error: Error) {
            self.error = error
        }
    }
    
    class NnListRemoteAPISpy {
        
        var list = [TestItem]()
        var deletedItem: TestItem?
        private var completion:  ((Error?) -> Void)?
        
        func upload(_ list: [TestItem],
                    completion: @escaping (Error?) -> Void) {
            
            self.list = list
            self.completion = completion
        }
        
        func delete(_ list: [TestItem],
                    deletedItem: TestItem,
                    completion: @escaping (Error?) -> Void) {
            
            self.list = list
            self.deletedItem = deletedItem
            self.completion = completion
        }
        
        func complete(with error: TestError?,
                      file: StaticString = #filePath,
                      line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            completion(error)
        }
        
        func makeRemote() -> NnListRemoteAPI<TestItem> {
            (upload: upload(_:completion:),
             delete: delete(_:deletedItem:completion:))
        }
    }
}
