//
//  MockNnListNameValidator.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import NnListKit
import Foundation

final class MockNnListNameValidator: NnListNameValidator {
    
    private let error: TestError?
    
    init(error: TestError? = nil) {
        self.error = error
    }
    
    func validateName(_ name: String) throws {
        if let error = error { throw error }
    }
}
