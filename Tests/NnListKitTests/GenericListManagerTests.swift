//
//  GenericListManagerTests.swift
//
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import XCTest
import NnListKit

final class GenericListManagerTests: XCTestCase {
    
    // MARK: Init Tests
    func test_init_alertsEmpty() {
        let (_, alerts) = makeSUTOnlyAlerts()
    
        XCTAssertNil(alerts.error)
    }
    
    
    // MARK: Policy Error Tests
    func test_addNew_policyError() {
        let policy = makePolicy(error: .addError)
        let (sut, alerts) = makeSUTOnlyAlerts(policy: policy)

        expectError(.addError, from: alerts) {
            sut.addNew()
        }
    }
    
    func test_edit_policyError() {
        let item = makeItem()
        let policy = makePolicy(error: .editError)
        let (sut, alerts) = makeSUTOnlyAlerts(policy: policy)

        expectError(.editError, from: alerts) {
            sut.edit(item)
        }
    }
    
    func test_delete_policyError() {
        let item = makeItem()
        let policy = makePolicy(error: .deleteError)
        let (sut, alerts) = makeSUTOnlyAlerts(policy: policy)

        expectError(.deleteError, from: alerts) {
            sut.delete(item)
        }
    }
    
    
    // MARK: - Modifier Error Tests
    func test_addNew_modifierError() {
        let (sut, alerts, modifier) = makeSUTModTests()

        expectError(.addModError, from: alerts) {
            sut.addNew()
            modifier.complete(with: .addModError)
        }
    }
    
    func test_edit_modifierError() {
        let item = makeItem()
        let (sut, alerts, modifier) = makeSUTModTests()

        expectError(.editModError, from: alerts) {
            sut.edit(item)
            modifier.complete(with: .editModError)
        }
    }
    
    // MARK: Remote Tests
    func test_addNew_remoteError() {
        let (sut, alerts, modifier, remote) = makeSUTRemoteTests()
        
        expectError(.remoteError, from: alerts) {
            sut.addNew()
            modifier.complete([])
            remote.complete(with: .remoteError)
        }
    }

    func test_addNew_success() {
        let (sut, alerts, modifier, remote) = makeSUTRemoteTests()

        expectError(nil, from: alerts) {
            sut.addNew()
            modifier.complete([])
            remote.complete(with: nil)
        }
    }
    
    func test_edit_remoteError() {
        let item = makeItem()
        let (sut, alerts, modifier, remote) = makeSUTRemoteTests()

        expectError(.remoteError, from: alerts) {
            sut.edit(item)
            modifier.complete([])
            remote.complete(with: .remoteError)
        }
    }

    func test_edit_success() {
        let item = makeItem()
        let (sut, alerts, modifier, remote) = makeSUTRemoteTests()

        expectError(nil, from: alerts) {
            sut.edit(item)
            modifier.complete([])
            remote.complete(with: nil)
        }
    }
    
    func test_delete_remoteError() {
        let item = makeItem()
        let (sut, alerts, modifier, remote) = makeSUTRemoteTests()

        expectError(.remoteError, from: alerts) {
            sut.delete(item)
            modifier.deleteComplete([])
            remote.complete(with: .remoteError)
        }
    }

    func test_delete_success() {
        let item = makeItem()
        let (sut, alerts, modifier, remote) = makeSUTRemoteTests()

        expectError(nil, from: alerts) {
            sut.delete(item)
            modifier.deleteComplete([])
            remote.complete(with: nil)
        }
    }
    
    func test_uploadReorderedList_remoteError() {
        let (sut, alerts, _, remote) = makeSUTRemoteTests()

        expectError(.remoteError, from: alerts) {
            sut.uploadReorderedList([])
            remote.complete(with: .remoteError)
        }
    }

    func test_uploadReorderedList_success() {
        let (sut, alerts, _, remote) = makeSUTRemoteTests()

        expectError(nil, from: alerts) {
            sut.uploadReorderedList([])
            remote.complete(with: nil)
        }
    }
}


// MARK: - Assertion Helpers
extension GenericListManagerTests {
    
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
extension GenericListManagerTests {
    
    func makeSUTOnlyAlerts(policy: NnListPolicy? = nil,
                           file: StaticString = #filePath,
                           line: UInt = #line) -> (sut: GenericListManager<NnListRemoteAPISpy, NnListModifierSpy>, alerts: MockNnListManagerAlerts) {
        
        let alerts = MockNnListManagerAlerts()
        let sut = GenericListManager(policy: policy ?? makePolicy(),
                                     alerts: alerts,
                                     remote: NnListRemoteAPISpy(),
                                     modifier: NnListModifierSpy())

        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts)
    }
    
    func makeSUTModTests(file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: GenericListManager<NnListRemoteAPISpy, NnListModifierSpy>, alerts: MockNnListManagerAlerts, modifier: NnListModifierSpy) {
        
        let alerts = MockNnListManagerAlerts()
        let modifier = NnListModifierSpy()
        let sut = GenericListManager(policy: makePolicy(),
                                     alerts: alerts,
                                     remote: NnListRemoteAPISpy(),
                                     modifier: modifier)

        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts, modifier)
    }
    
    func makeSUTRemoteTests(file: StaticString = #filePath,
                            line: UInt = #line) -> (sut: GenericListManager<NnListRemoteAPISpy, NnListModifierSpy>, alerts: MockNnListManagerAlerts, modifier: NnListModifierSpy, remote: NnListRemoteAPISpy) {
        
        let alerts = MockNnListManagerAlerts()
        let modifier = NnListModifierSpy()
        let remote = NnListRemoteAPISpy()
        let sut = GenericListManager(policy: makePolicy(),
                                     alerts: alerts,
                                     remote: remote,
                                     modifier: modifier)

        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, alerts, modifier, remote)
    }
    
    func makePolicy(error: TestError? = nil) -> NnListPolicy {
        MockNnListPolicy(error: error)
    }
}


// MARK: - Helper Classes
extension GenericListManagerTests {
    
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
        
        func verifyCanDelete() throws {
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
    
    class NnListRemoteAPISpy: NnListRemoteAPI {
        
        typealias Item = TestItem
        
        var list = [TestItem]()
        var deletedItem: TestItem?
        private var completion:  ((Error?) -> Void)?
        
        func upload(_ list: [TestItem],
                    deletedItem: TestItem?,
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
    }
    
    class NnListModifierSpy: NnListModifer {
        
        typealias Item = TestItem
        
        var item: TestItem?
        private var completion: ((Result<[TestItem], Error>) -> Void)?
        private var deleteCompletion: (([TestItem]) -> Void)?
        
        func addNew(completion: @escaping (Result<[TestItem], Error>) -> Void) {
            
            self.completion = completion
        }
        
        func edit(_ item: TestItem,
                  completion: @escaping (Result<[TestItem], Error>) -> Void) {
            
            self.item = item
            self.completion = completion
        }
        
        func delete(_ item: TestItem,
                    completion: @escaping ([TestItem]) -> Void) {
            
            self.item = item
            self.deleteCompletion = completion
        }
        
        func complete(with error: TestError,
                      file: StaticString = #filePath,
                      line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            completion(.failure(error))
        }
        
        func complete(_ list: [TestItem],
                      file: StaticString = #filePath,
                      line: UInt = #line) {
            guard
                let completion = completion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            completion(.success(list))
        }
        
        func deleteComplete(_ list: [TestItem],
                      file: StaticString = #filePath,
                      line: UInt = #line) {
            guard
                let deleteCompletion = deleteCompletion
            else {
                return XCTFail("Request never made", file: file, line: line)
            }
            
            deleteCompletion(list)
        }
    }
}
