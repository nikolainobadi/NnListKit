//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import NnListKit
import Foundation

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
