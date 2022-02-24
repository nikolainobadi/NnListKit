//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import NnListKit

final class MockNnListItemCache: NnListItemCache {
    
    var items: [TestItem]
    
    init(_ items: [TestItem]) {
        self.items = items
    }
    
    func getItems<T>() -> [T] where T: NnListItem {
        items.compactMap { $0 as? T }
    }
}
