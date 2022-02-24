//
//  XCTestCase+MemoryLeakTracking.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import XCTest
import NnListKit

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject,
                             file: StaticString = #filePath,
                             line: UInt = #line) {
        
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

extension XCTestCase {
    
    func makeItem(id: String = "TestId",
                  name: String = "TestName") -> TestItem {
        
        TestItem(id: id, name: name)
    }
}
