//
//  NnListManagerTests.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import XCTest
import NnListKit

final class NnListManagerTests: XCTestCase {
    
    
}


// MARK: - SUT
extension NnListManagerTests {
    
    func makeSUT(policy: NnListPolicy? = nil,
                 file: StaticString = #filePath, line: UInt = #line) {
        
//        let alerts = MockNnListManagerAlerts()
//        let remote = NnListRemoteAPISpy()
//        let sut = NnListManager<TestItem>(
//            policy: policy ?? makePolicy(),
//            alerts: alerts,
//            remote: remote,
//            modifier: <#T##GenericListModifier<_>#>)
//
//        trackForMemoryLeaks(sut, file: file, line: line)
    }
    
//    func makeModifier<T: NnListItem) -> GenericListModifier<T> {
//        
//        GenericListModifier<T>(cache: <#NnListItemCache#>,
//                               factory: <#NnListItemFactory#>,
//                               alerts: <#NnListModifierAlerts#>,
//                               validator: <#NnListNameValidator#>
//    }
    
    func makePolicy(canAdd: Bool = false,
                    canEdit: Bool = false) -> NnListPolicy {
        
        MockNnListPolicy(canAdd: canAdd, canEdit: canEdit)
    }
}


// MARK: - Helper Classes
extension NnListManagerTests {
    
    class MockNnListPolicy: NnListPolicy {
        
        let canAdd: Bool
        let canEdit: Bool
        
        var error: Error {
            NSError(domain: "Test", code: 0)
        }
        
        init(canAdd: Bool = false, canEdit: Bool = false) {
            self.canAdd = canAdd
            self.canEdit = canEdit
        }
        
        func verifyCanAdd() throws {
            guard canAdd else { throw error }
        }
        
        func verifyCanEdit() throws {
            guard canEdit else { throw error }
        }
    }
    
    class MockNnListManagerAlerts: NnListManagerAlerts {
        
        var error: Error?
        
        func showError(_ error: Error) {
            self.error = error
        }
    }
    
    class NnListRemoteAPISpy: NnListRemoteAPI {
        
        private var completion:  ((Error?) -> Void)?
        
        func upload<T>(_ list: [T],
                       isDeleting: Bool,
                       completion: @escaping (Error?) -> Void) where T: NnListItem {
            
            self.completion = completion
        }
        
        func complete(with error: Error?,
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
}
