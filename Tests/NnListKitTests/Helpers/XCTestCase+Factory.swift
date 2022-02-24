//
//  XCTestCase+Factory.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import XCTest
import NnListKit

extension XCTestCase {
    
    func makeModifier(cache: NnListItemCache? = nil,
                      factory: NnListItemFactory? = nil,
                      alerts: NnListModifierAlerts? = nil,
                      validator: NnListNameValidator? = nil) -> GenericListModifier<TestItem> {
        
        return GenericListModifier<TestItem>(
            cache: cache ?? makeCache(),
            factory: factory ?? MockNnListItemFactory(),
            alerts: alerts ?? makeAlerts(),
            validator: validator ?? makeValidator())
    }
    
    func makeAlerts(_ name: String = "name") -> NnListModifierAlerts {
        
        MockNnListModifierAlerts(name)
    }
    
    func makeCache(_ items: [TestItem] = []) -> MockNnListItemCache {
        
        MockNnListItemCache(items)
    }
    
    func makeValidator(_ modError: TestError? = nil) -> MockNnListNameValidator  {
        
        MockNnListNameValidator(error: modError)
    }
}
